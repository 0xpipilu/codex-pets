import SwiftUI
import AppKit
import ApplicationServices

@MainActor
final class CodpetHybridStore: ObservableObject {
    @Published var repoRoot: URL?
    @Published var catalog: [PetIndexEntry] = []
    @Published var installedPets: [InstalledPet] = []
    @Published var activePetSlug: String?
    @Published var statusMessage: String?
    @Published var applyMode: CodexApplyMode {
        didSet {
            UserDefaults.standard.set(applyMode.rawValue, forKey: Self.applyModeDefaultsKey)
        }
    }
    
    private static let applyModeDefaultsKey = "hybridCodexApplyMode"
    private let fileManager = FileManager.default
    private let codexBundleIdentifier = "com.openai.codex"
    private let codexSettingURL = "vscode://codex/set-setting"
    
    var catalogCount: Int {
        catalog.count
    }
    
    var installedCount: Int {
        installedPets.count
    }
    
    var activePetName: String {
        guard let activePetSlug else { return "未选择" }
        return installedPets.first(where: { $0.slug == activePetSlug })?.displayName
            ?? catalog.first(where: { $0.slug == activePetSlug })?.displayName
            ?? activePetSlug
    }
    
    var codexDir: URL {
        fileManager.homeDirectoryForCurrentUser.appendingPathComponent(".codex")
    }
    
    var petsDir: URL {
        codexDir.appendingPathComponent("pets")
    }
    
    var configTomlURL: URL {
        codexDir.appendingPathComponent("config.toml")
    }
    
    init() {
        if let rawValue = UserDefaults.standard.string(forKey: Self.applyModeDefaultsKey),
           let savedMode = CodexApplyMode(rawValue: rawValue) {
            applyMode = savedMode
        } else {
            applyMode = .softReload
        }
        
        refreshAll()
    }
    
    func refreshAll() {
        repoRoot = Self.locateRepositoryRoot()
        loadCatalog()
        refreshInstalledPets()
        refreshActivePet()
    }
    
    func syncFromCodex() {
        refreshActivePet()
        refreshInstalledPets()
    }
    
    func loadCatalog() {
        guard let repoRoot else {
            catalog = []
            return
        }
        
        let indexURL = repoRoot.appendingPathComponent("index.json")
        guard let data = try? Data(contentsOf: indexURL),
              let decoded = try? JSONDecoder().decode(PetCatalog.self, from: data) else {
            catalog = []
            return
        }
        
        catalog = decoded.pets
    }
    
    func refreshInstalledPets() {
        if !fileManager.fileExists(atPath: petsDir.path) {
            try? fileManager.createDirectory(at: petsDir, withIntermediateDirectories: true, attributes: nil)
        }
        
        guard let contents = try? fileManager.contentsOfDirectory(
            at: petsDir,
            includingPropertiesForKeys: nil,
            options: [.skipsHiddenFiles]
        ) else {
            installedPets = []
            return
        }
        
        let pets = contents.compactMap { folderURL -> InstalledPet? in
            var isDirectory: ObjCBool = false
            guard fileManager.fileExists(atPath: folderURL.path, isDirectory: &isDirectory), isDirectory.boolValue else {
                return nil
            }
            
            let petJSONURL = folderURL.appendingPathComponent("pet.json")
            guard let data = try? Data(contentsOf: petJSONURL) else {
                return nil
            }
            
            let slug = folderURL.lastPathComponent
            let fallbackDescription = "Local Codex pet."
            let fallbackDisplayName = catalog.first(where: { $0.slug == slug })?.displayName ?? slug.capitalized
            let localConfig = try? JSONDecoder().decode(LocalPetConfig.self, from: data)
            
            return InstalledPet(
                slug: slug,
                displayName: localConfig?.displayName ?? fallbackDisplayName,
                description: localConfig?.description ?? fallbackDescription,
                folderURL: folderURL,
                previewImageURL: Self.firstExistingURL(
                    at: folderURL,
                    candidates: ["base.png", "base.webp", "spritesheet.webp"]
                )
            )
        }
        
        installedPets = pets.sorted { lhs, rhs in
            let lhsIsActive = lhs.slug == activePetSlug
            let rhsIsActive = rhs.slug == activePetSlug
            if lhsIsActive != rhsIsActive {
                return lhsIsActive
            }
            return lhs.displayName.localizedCaseInsensitiveCompare(rhs.displayName) == .orderedAscending
        }
    }
    
    func refreshActivePet() {
        guard let content = try? String(contentsOf: configTomlURL, encoding: .utf8) else {
            activePetSlug = nil
            return
        }
        
        let lines = content.components(separatedBy: .newlines)
        var inDesktopSection = false
        var resolvedSlug: String?
        
        for line in lines {
            let trimmed = line.trimmingCharacters(in: .whitespaces)
            if trimmed == "[desktop]" {
                inDesktopSection = true
                continue
            }
            
            if trimmed.hasPrefix("[") && trimmed.hasSuffix("]") {
                inDesktopSection = false
            }
            
            if inDesktopSection, trimmed.hasPrefix("selected-avatar-id") {
                let value = trimmed
                    .components(separatedBy: "=")
                    .dropFirst()
                    .joined(separator: "=")
                    .trimmingCharacters(in: .whitespaces)
                    .replacingOccurrences(of: "\"", with: "")
                    .replacingOccurrences(of: "'", with: "")
                
                resolvedSlug = value.hasPrefix("custom:")
                    ? String(value.dropFirst("custom:".count))
                    : value
            }
        }
        
        activePetSlug = resolvedSlug
    }
    
    func installPet(slug: String) {
        guard let repoRoot else {
            statusMessage = "没有找到 cod.pet 仓库目录。"
            return
        }
        
        let source = repoRoot.appendingPathComponent("pets").appendingPathComponent(slug)
        let destination = petsDir.appendingPathComponent(slug)
        let petName = displayName(for: slug)
        
        guard fileManager.fileExists(atPath: source.path) else {
            statusMessage = "仓库里缺少 \(petName) 的资源文件。"
            return
        }
        
        do {
            if fileManager.fileExists(atPath: destination.path) {
                statusMessage = "\(petName) 已经安装过了。"
                return
            }
            
            try fileManager.createDirectory(at: petsDir, withIntermediateDirectories: true, attributes: nil)
            try fileManager.copyItem(at: source, to: destination)
            refreshInstalledPets()
            statusMessage = "已安装 \(petName)。"
        } catch {
            statusMessage = "安装 \(petName) 失败：\(error.localizedDescription)"
        }
    }
    
    func importPetFromFolder() {
        let panel = NSOpenPanel()
        panel.canChooseDirectories = true
        panel.canChooseFiles = false
        panel.allowsMultipleSelection = false
        panel.prompt = "导入"
        panel.message = "选择一个包含 pet.json 和 spritesheet 的 Pet 文件夹。"
        
        guard panel.runModal() == .OK, let source = panel.url else {
            return
        }
        
        let petJSONURL = source.appendingPathComponent("pet.json")
        guard fileManager.fileExists(atPath: petJSONURL.path) else {
            statusMessage = "所选文件夹里没有 pet.json，无法导入。"
            return
        }
        
        let slug = source.lastPathComponent
        let destination = petsDir.appendingPathComponent(slug)
        
        do {
            try fileManager.createDirectory(at: petsDir, withIntermediateDirectories: true, attributes: nil)
            if fileManager.fileExists(atPath: destination.path) {
                try fileManager.removeItem(at: destination)
            }
            try fileManager.copyItem(at: source, to: destination)
            refreshInstalledPets()
            statusMessage = "已导入本地 Pet：\(slug)。"
        } catch {
            statusMessage = "导入本地 Pet 失败：\(error.localizedDescription)"
        }
    }
    
    func uninstallPet(slug: String) {
        let destination = petsDir.appendingPathComponent(slug)
        let petName = displayName(for: slug)
        do {
            guard fileManager.fileExists(atPath: destination.path) else { return }
            try fileManager.removeItem(at: destination)
            if activePetSlug == slug {
                _ = clearActivePet()
            }
            refreshInstalledPets()
            statusMessage = "已删除 \(petName)。"
        } catch {
            statusMessage = "删除 \(petName) 失败：\(error.localizedDescription)"
        }
    }
    
    @discardableResult
    func applyPet(slug: String) -> Bool {
        if !fileManager.fileExists(atPath: codexDir.path) {
            try? fileManager.createDirectory(at: codexDir, withIntermediateDirectories: true, attributes: nil)
        }
        
        var lines: [String] = []
        if let content = try? String(contentsOf: configTomlURL, encoding: .utf8) {
            lines = content.components(separatedBy: .newlines)
        }
        
        var desktopIndex: Int?
        var avatarIndex: Int?
        for (index, line) in lines.enumerated() {
            let trimmed = line.trimmingCharacters(in: .whitespaces)
            if trimmed == "[desktop]" {
                desktopIndex = index
                continue
            }
            if desktopIndex != nil, trimmed.hasPrefix("selected-avatar-id") {
                avatarIndex = index
            }
        }
        
        let newSetting = "selected-avatar-id = \"custom:\(slug)\""
        if let avatarIndex {
            lines[avatarIndex] = newSetting
        } else if let desktopIndex {
            lines.insert(newSetting, at: desktopIndex + 1)
        } else {
            lines.append("")
            lines.append("[desktop]")
            lines.append(newSetting)
        }
        
        do {
            try lines.joined(separator: "\n").write(to: configTomlURL, atomically: false, encoding: .utf8)
            refreshActivePet()
            refreshInstalledPets()
            applySelectionSideEffect(slug: slug)
            return true
        } catch {
            statusMessage = "应用 \(displayName(for: slug)) 失败：\(error.localizedDescription)"
            return false
        }
    }
    
    @discardableResult
    func clearActivePet() -> Bool {
        guard let content = try? String(contentsOf: configTomlURL, encoding: .utf8) else {
            return true
        }
        
        var lines = content.components(separatedBy: .newlines)
        var desktopIndex = -1
        var avatarIndex = -1
        
        for (index, line) in lines.enumerated() {
            let trimmed = line.trimmingCharacters(in: .whitespaces)
            if trimmed == "[desktop]" {
                desktopIndex = index
                continue
            }
            if desktopIndex != -1 {
                if trimmed.hasPrefix("[") && trimmed.hasSuffix("]") {
                    break
                }
                if trimmed.hasPrefix("selected-avatar-id") {
                    avatarIndex = index
                    break
                }
            }
        }
        
        if avatarIndex != -1 {
            lines.remove(at: avatarIndex)
            try? lines.joined(separator: "\n").write(to: configTomlURL, atomically: false, encoding: .utf8)
        }
        
        refreshActivePet()
        refreshInstalledPets()
        statusMessage = "已清除当前 Pet 选择。"
        return true
    }
    
    func revealCodexPetsFolder() {
        NSWorkspace.shared.activateFileViewerSelecting([petsDir])
    }
    
    func revealRepositoryRoot() {
        guard let repoRoot else { return }
        NSWorkspace.shared.activateFileViewerSelecting([repoRoot])
    }
    
    func webStoreURL() -> URL? {
        repoRoot?.appendingPathComponent("index.html")
    }
    
    func installedSlugsJSON() -> String {
        let payload: [String: Any] = [
            "installed": installedPets.map(\.slug),
            "active": activePetSlug ?? ""
        ]
        
        guard let data = try? JSONSerialization.data(withJSONObject: payload),
              let string = String(data: data, encoding: .utf8) else {
            return #"{"installed":[],"active":""}"#
        }
        
        return string
    }
    
    func diagnoseCodexBridge() {
        guard !NSRunningApplication.runningApplications(withBundleIdentifier: codexBundleIdentifier).isEmpty else {
            statusMessage = "诊断结果：Codex 还没有在运行。先打开 Codex，再测试应用桥。"
            return
        }
        
        let javascript = """
        (() => {
          try {
            return JSON.stringify({
              ok: true,
              title: document.title || "",
              href: String(location.href || ""),
              readyState: document.readyState || "",
              hasElectronBridge: !!window.electronBridge,
              canSendMessage: !!(window.electronBridge && typeof window.electronBridge.sendMessageFromView === "function")
            });
          } catch (error) {
            return JSON.stringify({ ok: false, code: "js-error", error: String(error) });
          }
        })()
        """
        
        switch executeInCodexActiveTab(javascript: javascript) {
        case .failure(let message):
            statusMessage = "诊断结果：\(message)"
        case .success(let rawResult):
            guard let data = rawResult.data(using: String.Encoding.utf8),
                  let response = try? JSONSerialization.jsonObject(with: data) as? [String: Any] else {
                statusMessage = "诊断结果：已连到 Codex，但没有拿到可解析的页面信息。"
                return
            }
            
            if (response["ok"] as? Bool) != true {
                let code = response["code"] as? String
                let details = response["error"] as? String
                statusMessage = "诊断结果：\(codexBridgeMessage(for: code, details: details))"
                return
            }
            
            let title = response["title"] as? String ?? "未知页面"
            let href = response["href"] as? String ?? "未知地址"
            let readyState = response["readyState"] as? String ?? "unknown"
            let hasBridge = (response["hasElectronBridge"] as? Bool) == true
            let canSendMessage = (response["canSendMessage"] as? Bool) == true
            statusMessage = "诊断结果：已连到 Codex 页面「\(title)」，状态 \(readyState)，bridge=\(hasBridge ? "已注入" : "缺失")，send=\(canSendMessage ? "可调用" : "不可调用")，地址 \(href)"
        }
    }

    private func applySelectionSideEffect(slug: String) {
        let petName = displayName(for: slug)
        switch applyMode {
        case .softReload:
            statusMessage = "正在尝试即时热重载..."
            attemptCDPSettingInjection(slug: slug) { success in
                Task { @MainActor in
                    if success {
                        self.statusMessage = "已通过 CDP 即时切换到宠物 \(petName)。"
                    } else {
                        // Fallback to old AppleScript bridge
                        switch self.applyPetViaCodexBridge(slug: slug) {
                        case .success:
                            self.statusMessage = "已通过 Codex 内部应用接口切换到 \(petName)。"
                        case .failure(let reason):
                            if self.reloadCodexWindow() {
                                self.statusMessage = "已记录 \(petName)，但即时刷新不可用；已通过窗口刷新载入。\(reason)"
                            } else {
                                self.statusMessage = "已记录 \(petName)，但即时刷新失败。\(reason)"
                            }
                        }
                    }
                }
            }
        case .restartCodex:
            if restartCodexApp() {
                statusMessage = "已应用 \(petName)，并已重启 Codex。"
            } else {
                statusMessage = "已应用 \(petName)，但无法自动重启 Codex。"
            }
        case .manual:
            statusMessage = "已应用 \(petName)。请回到 Codex 内手动刷新或重新选择。"
        }
    }

    // Connects to local DevTools socket, writes settings, and invalidates overlay cache
    nonisolated public func attemptCDPSettingInjection(slug: String, completion: @escaping (Bool) -> Void) {
        guard let jsonURL = URL(string: "http://localhost:9222/json") else {
            completion(false)
            return
        }
        
        let config = URLSessionConfiguration.default
        config.timeoutIntervalForRequest = 1.0
        let session = URLSession(configuration: config)
        
        let task = session.dataTask(with: jsonURL) { data, response, error in
            guard error == nil, let data = data else {
                completion(false)
                return
            }
            
            do {
                guard let jsonArray = try JSONSerialization.jsonObject(with: data, options: []) as? [[String: Any]] else {
                    completion(false)
                    return
                }
                
                // Find main window target: url == "app://-/index.html" (not the overlay)
                let mainTarget = jsonArray.first(where: {
                    let url = $0["url"] as? String ?? ""
                    let type = $0["type"] as? String ?? ""
                    return url == "app://-/index.html" && type == "page" && !url.contains("initialRoute")
                })
                
                // Find overlay target: url contains "avatar-overlay"
                let overlayTarget = jsonArray.first(where: {
                    let url = $0["url"] as? String ?? ""
                    let type = $0["type"] as? String ?? ""
                    return url.contains("avatar-overlay") && type == "page"
                })
                
                guard let mainTarget = mainTarget,
                      let mainWsUrlString = mainTarget["webSocketDebuggerUrl"] as? String,
                      let mainWsURL = URL(string: mainWsUrlString) else {
                    completion(false)
                    return
                }
                
                let overlayWsURL: URL?
                if let overlayTarget = overlayTarget,
                   let overlayWsUrlString = overlayTarget["webSocketDebuggerUrl"] as? String {
                    overlayWsURL = URL(string: overlayWsUrlString)
                } else {
                    overlayWsURL = nil
                }
                
                // Step 1: Write setting to Main Window
                self.sendCDPWriteSetting(wsURL: mainWsURL, slug: slug) { success in
                    if success {
                        if let overlayWsURL = overlayWsURL {
                            // Step 2: Wait 500ms for backend flush, then invalidate overlay cache
                             DispatchQueue.global().asyncAfter(deadline: .now() + 0.5) {
                                self.sendCDPInvalidateCache(wsURL: overlayWsURL, slug: slug) { _ in
                                    // Complete with true regardless of invalidation success since setting was written
                                    completion(true)
                                }
                            }
                        } else {
                            completion(true)
                        }
                    } else {
                        completion(false)
                    }
                }
            } catch {
                completion(false)
            }
        }
        task.resume()
    }
    
    nonisolated private func sendCDPWriteSetting(wsURL: URL, slug: String, completion: @escaping (Bool) -> Void) {
        let webSocketTask = URLSession.shared.webSocketTask(with: wsURL)
        
        webSocketTask.receive { result in
            switch result {
            case .success(let message):
                switch message {
                case .string(let text):
                    print("CDP Main Window Received: \(text)")
                    if text.contains("settings-written-and-flushed") || text.contains("event-dispatched") {
                        completion(true)
                    } else {
                        completion(false)
                    }
                default:
                    completion(false)
                }
            case .failure(let error):
                print("CDP Main receive error: \(error)")
                completion(false)
            }
            webSocketTask.cancel()
        }
        
        webSocketTask.resume()
        
        let escapedSlug = slug.replacingOccurrences(of: "\"", with: "\\\"")
        let expression = """
        (async function() {
            const msg = {
                type: "fetch",
                requestId: "poc-write-" + Date.now(),
                url: "vscode://codex/settings-write",
                method: "POST",
                body: JSON.stringify({
                    settings: {
                        "selected-avatar-id": "custom:\(escapedSlug)"
                    }
                })
            };
            
            if (window.electronBridge && typeof window.electronBridge.sendMessageFromView === 'function') {
                await window.electronBridge.sendMessageFromView(msg);
                return "settings-written-and-flushed";
            }
            
            window.dispatchEvent(new CustomEvent("codex-message-from-view", { detail: msg }));
            return "event-dispatched";
        })()
        """
        
        let cdpMessage: [String: Any] = [
            "id": 1,
            "method": "Runtime.evaluate",
            "params": [
                "expression": expression,
                "awaitPromise": true,
                "returnByValue": true
            ]
        ]
        
        guard let jsonData = try? JSONSerialization.data(withJSONObject: cdpMessage, options: []),
              let jsonString = String(data: jsonData, encoding: .utf8) else {
            webSocketTask.cancel()
            completion(false)
            return
        }
        
        let outgoingMessage = URLSessionWebSocketTask.Message.string(jsonString)
        webSocketTask.send(outgoingMessage) { error in
            if let error = error {
                print("CDP Main send error: \(error)")
                webSocketTask.cancel()
                completion(false)
            }
        }
    }
    
    nonisolated private func sendCDPInvalidateCache(wsURL: URL, slug: String, completion: @escaping (Bool) -> Void) {
        let webSocketTask = URLSession.shared.webSocketTask(with: wsURL)
        
        webSocketTask.receive { result in
            switch result {
            case .success(let message):
                switch message {
                case .string(let text):
                    print("CDP Invalidate Received: \(text)")
                    if text.contains("invalidated") {
                        completion(true)
                    } else {
                        completion(false)
                    }
                default:
                    completion(false)
                }
            case .failure(let error):
                print("CDP Invalidate receive error: \(error)")
                completion(false)
            }
            webSocketTask.cancel()
        }
        
        webSocketTask.resume()
        
        let expression = """
        (async function() {
            try {
                // Preload the spritesheet image to browser cache first
                await new Promise((resolve) => {
                    const img = new Image();
                    img.onload = () => resolve("loaded");
                    img.onerror = () => resolve("error");
                    img.src = "app://-/pets/\(slug)/spritesheet.webp";
                    // 600ms timeout fallback
                    setTimeout(() => resolve("timeout"), 600);
                });
                
                const rootEl = document.getElementById('root') || document.querySelector('[data-avatar-overlay-content-frame]');
                if (!rootEl) return "no_root";
                
                const getReactFiber = (el) => {
                    const keys = Object.keys(el);
                    const key = keys.find(k => k.startsWith('__reactContainer$') || k.startsWith('__reactFiber$'));
                    return key ? el[key] : null;
                };

                const fiber = getReactFiber(rootEl);
                if (!fiber) return "no_fiber";

                let queryClient = null;
                const traverse = (node) => {
                    if (!node) return;
                    if (node.tag === 10 && node.pendingProps && node.pendingProps.value) {
                        const val = node.pendingProps.value;
                        if (val && typeof val === 'object' && typeof val.invalidateQueries === 'function') {
                            queryClient = val;
                        }
                    }
                    if (node.child) traverse(node.child);
                    if (node.sibling) traverse(node.sibling);
                };

                traverse(fiber);
                if (queryClient) {
                    queryClient.invalidateQueries();
                    return "invalidated";
                }
                return "no_client";
            } catch (err) {
                return "error_" + err.message;
            }
        })()
        """
        
        let cdpMessage: [String: Any] = [
            "id": 2,
            "method": "Runtime.evaluate",
            "params": [
                "expression": expression,
                "awaitPromise": true,
                "returnByValue": true
            ]
        ]
        
        guard let jsonData = try? JSONSerialization.data(withJSONObject: cdpMessage, options: []),
              let jsonString = String(data: jsonData, encoding: .utf8) else {
            webSocketTask.cancel()
            completion(false)
            return
        }
        
        let outgoingMessage = URLSessionWebSocketTask.Message.string(jsonString)
        webSocketTask.send(outgoingMessage) { error in
            if let error = error {
                print("CDP Invalidate send error: \(error)")
                webSocketTask.cancel()
                completion(false)
            }
        }
    }


    private func applyPetViaCodexBridge(slug: String) -> CodexBridgeApplyResult {
        guard !NSRunningApplication.runningApplications(withBundleIdentifier: codexBundleIdentifier).isEmpty else {
            return .failure("Codex 当前没有在运行。")
        }
        
        let javascript = makeCodexBridgeInjection(slug: slug)
        let rawResult: String
        switch executeInCodexActiveTab(javascript: javascript) {
        case .failure(let error):
            switch error {
            case .executionFailed(let message):
                return .failure(message)
            }
        case .success(let result):
            rawResult = result
        }
        
        guard !rawResult.isEmpty else {
            return .success
        }
        
        guard let data = rawResult.data(using: String.Encoding.utf8),
              let response = try? JSONSerialization.jsonObject(with: data) as? [String: Any] else {
            return .success
        }
        
        if (response["ok"] as? Bool) == true {
            return .success
        }
        
        let code = response["code"] as? String
        let message = response["error"] as? String
        return .failure(codexBridgeMessage(for: code, details: message))
    }
    
    private func reloadCodexWindow() -> Bool {
        let scriptText = """
        tell application "Codex" to activate
        delay 0.2
        tell application "System Events"
            if exists process "Codex" then
                keystroke "r" using {command down}
                return true
            else
                return false
            end if
        end tell
        """
        
        var error: NSDictionary?
        guard let script = NSAppleScript(source: scriptText) else {
            return false
        }
        let output = script.executeAndReturnError(&error)
        return error == nil && output.booleanValue
    }
    
    private func restartCodexApp() -> Bool {
        let runningApps = NSRunningApplication.runningApplications(withBundleIdentifier: codexBundleIdentifier)
        for app in runningApps {
            _ = app.terminate()
        }
        
        let codexURL = URL(fileURLWithPath: "/Applications/Codex.app")
        let semaphore = DispatchSemaphore(value: 0)
        var success = false
        
        DispatchQueue.main.async {
            let configuration = NSWorkspace.OpenConfiguration()
            configuration.activates = true
            configuration.arguments = ["--remote-debugging-port=9222"]
            NSWorkspace.shared.openApplication(at: codexURL, configuration: configuration) { app, error in
                success = app != nil && error == nil
                semaphore.signal()
            }
        }
        
        _ = semaphore.wait(timeout: .now() + 5)
        return success
    }
    
    static func locateRepositoryRoot() -> URL? {
        var candidates: [URL] = []
        
        if let envPath = ProcessInfo.processInfo.environment["CODPET_REPO_ROOT"] {
            candidates.append(URL(fileURLWithPath: envPath))
        }
        
        let currentDirectory = URL(fileURLWithPath: fileManagerDefault.currentDirectoryPath)
        candidates.append(currentDirectory)
        candidates.append(contentsOf: ancestorCandidates(for: currentDirectory))
        
        let bundleDirectory = Bundle.main.bundleURL.deletingLastPathComponent()
        candidates.append(bundleDirectory)
        candidates.append(contentsOf: ancestorCandidates(for: bundleDirectory))
        
        for candidate in candidates {
            if looksLikeRepositoryRoot(candidate) {
                return candidate
            }
        }
        
        return nil
    }
    
    private static func ancestorCandidates(for url: URL) -> [URL] {
        var result: [URL] = []
        var current = url
        for _ in 0..<8 {
            current.deleteLastPathComponent()
            result.append(current)
        }
        return result
    }
    
    private static func looksLikeRepositoryRoot(_ url: URL) -> Bool {
        let fm = fileManagerDefault
        return fm.fileExists(atPath: url.appendingPathComponent("index.html").path) &&
            fm.fileExists(atPath: url.appendingPathComponent("index.json").path) &&
            fm.fileExists(atPath: url.appendingPathComponent("pets").path)
    }
    
    private static func firstExistingURL(at folder: URL, candidates: [String]) -> URL? {
        let fm = fileManagerDefault
        for candidate in candidates {
            let url = folder.appendingPathComponent(candidate)
            if fm.fileExists(atPath: url.path) {
                return url
            }
        }
        return nil
    }
    
    private func displayName(for slug: String) -> String {
        installedPets.first(where: { $0.slug == slug })?.displayName
            ?? catalog.first(where: { $0.slug == slug })?.displayName
            ?? slug
    }
    
    private func makeCodexBridgeInjection(slug: String) -> String {
        let payload = #"{"key":"selected-avatar-id","value":"custom:\#(slug)"}"#
        let escapedPayload = payload
            .replacingOccurrences(of: "\\", with: "\\\\")
            .replacingOccurrences(of: "\"", with: "\\\"")
        
        return """
        (() => {
          try {
            const requestId = `codpet-${Date.now()}-${Math.random().toString(16).slice(2)}`;
            const message = {
              type: "fetch",
              requestId,
              url: "\(codexSettingURL)",
              method: "POST",
              body: "\(escapedPayload)"
            };
            const bridge = window.electronBridge;
            if (bridge && typeof bridge.sendMessageFromView === "function") {
              bridge.sendMessageFromView(message).catch(() => {});
            }
            window.dispatchEvent(new CustomEvent("codex-message-from-view", { detail: message }));
            return JSON.stringify({ ok: true, requestId });
          } catch (error) {
            return JSON.stringify({ ok: false, code: "js-error", error: String(error) });
          }
        })()
        """
    }
    
    private func appleScriptEscaped(_ value: String) -> String {
        value
            .replacingOccurrences(of: "\\", with: "\\\\")
            .replacingOccurrences(of: "\"", with: "\\\"")
            .replacingOccurrences(of: "\n", with: "\\n")
    }
    
    private func codexBridgeErrorMessage(from error: NSDictionary) -> String {
        let code = error[NSAppleScript.errorNumber] as? Int
        let message = error[NSAppleScript.errorMessage] as? String
        
        switch code {
        case -1728:
            return "没有拿到可脚本化的 Codex 窗口。请先把 Codex 主窗口打开到前台。"
        case -1743:
            return "macOS 还没有允许这个 app 控制 Codex。请在系统设置里允许自动化权限。"
        default:
            if let message, !message.isEmpty {
                return "AppleScript 返回：\(message)"
            }
            if let code {
                return "AppleScript 错误码 \(code)。"
            }
            return "AppleScript 没有返回可用结果。"
        }
    }
    
    private func executeInCodexActiveTab(javascript: String) -> Result<String, BridgeError> {
        guard let app = NSRunningApplication.runningApplications(withBundleIdentifier: codexBundleIdentifier).first else {
            return .failure(.executionFailed("Codex 当前没有在运行。"))
        }
        
        app.activate(options: [.activateAllWindows, .activateIgnoringOtherApps])
        Thread.sleep(forTimeInterval: 0.2)
        
        let scriptText = """
        tell application id "\(codexBundleIdentifier)"
            if (count of windows) is 0 then return "{\\"ok\\":false,\\"code\\":\\"no-windows\\"}"
            set bridgeScript to "\(appleScriptEscaped(javascript))"
            return execute active tab of front window javascript bridgeScript
        end tell
        """
        
        var error: NSDictionary?
        guard let script = NSAppleScript(source: scriptText) else {
            return .failure(.executionFailed("无法创建 AppleScript 桥接脚本。"))
        }
        
        let descriptor = script.executeAndReturnError(&error)
        if let error {
            return .failure(.executionFailed(codexBridgeErrorMessage(from: error)))
        }
        
        return .success(descriptor.stringValue ?? "")
    }
    
    private func codexBridgeMessage(for code: String?, details: String?) -> String {
        switch code {
        case "no-windows":
            return "Codex 当前没有可用窗口。"
        case "js-error":
            if let details, !details.isEmpty {
                return "Codex 页内脚本执行失败：\(details)"
            }
            return "Codex 页内脚本执行失败。"
        default:
            if let details, !details.isEmpty {
                return details
            }
            return "Codex 没有确认这次应用请求。"
        }
    }
}

private let fileManagerDefault = FileManager.default

private enum CodexBridgeApplyResult {
    case success
    case failure(String)
}

enum BridgeError: Error {
    case executionFailed(String)
}
