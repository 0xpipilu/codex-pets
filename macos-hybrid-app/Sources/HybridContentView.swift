import SwiftUI
import WebKit
import AppKit
import Combine

struct HybridContentView: View {
    @EnvironmentObject private var store: CodpetHybridStore
    @State private var selectedTab: HybridTab? = .discover
    private let syncTimer = Timer.publish(every: 3, on: .main, in: .common).autoconnect()
    
    var body: some View {
        NavigationSplitView {
            List(selection: $selectedTab) {
                ForEach(HybridTab.allCases) { tab in
                    Label(tab.rawValue, systemImage: tab.iconName)
                        .tag(tab)
                }
            }
            .navigationTitle("Codpet")
        } detail: {
            VStack(spacing: 0) {
                HybridOverviewBar()
                
                if let statusMessage = store.statusMessage, !statusMessage.isEmpty {
                    HStack {
                        Image(systemName: "circle.fill")
                            .font(.system(size: 8))
                            .foregroundColor(.green)
                        Text(statusMessage)
                            .font(.subheadline)
                        Spacer()
                        Button("关闭") {
                            store.statusMessage = nil
                        }
                        .buttonStyle(.plain)
                    }
                    .padding(.horizontal, 16)
                    .padding(.vertical, 10)
                    .background(Color(NSColor.controlBackgroundColor))
                }
                
                switch selectedTab ?? .discover {
                case .discover:
                    DiscoverTabView()
                case .installed:
                    InstalledTabView()
                case .settings:
                    HybridSettingsView()
                }
            }
        }
        .frame(minWidth: 980, minHeight: 680)
        .onReceive(syncTimer) { _ in
            store.syncFromCodex()
        }
    }
}

struct HybridOverviewBar: View {
    @EnvironmentObject private var store: CodpetHybridStore
    
    var body: some View {
        HStack(spacing: 18) {
            Label("当前 Pet：\(store.activePetName)", systemImage: "sparkles")
            Label("仓库 \(store.catalogCount) 只", systemImage: "square.grid.2x2")
            Label("本地 \(store.installedCount) 只", systemImage: "pawprint.fill")
            Spacer()
            Button("同步 Codex 状态") {
                store.syncFromCodex()
            }
            .buttonStyle(.bordered)
        }
        .font(.subheadline)
        .padding(.horizontal, 18)
        .padding(.vertical, 12)
        .background(Color(NSColor.controlBackgroundColor))
    }
}

struct DiscoverTabView: View {
    @EnvironmentObject private var store: CodpetHybridStore
    
    var body: some View {
        if let pageURL = store.webStoreURL(), let repoRoot = store.repoRoot {
            ZStack(alignment: .topTrailing) {
                CodpetWebStoreView(pageURL: pageURL, readAccessRoot: repoRoot)
                
                VStack(alignment: .leading, spacing: 10) {
                    Text("Codpet 桌面桥接")
                        .font(.headline)
                    Text("浏览区保留 `cod.pet` 的原始体验；下载按钮已被接管为本地安装 / 应用。")
                        .font(.caption)
                        .foregroundColor(.secondary)
                    HStack(spacing: 8) {
                        Button("打开本地 Pet 文件夹") {
                            store.revealCodexPetsFolder()
                        }
                        .buttonStyle(.bordered)
                        
                        Button("导入本地 Pet") {
                            store.importPetFromFolder()
                        }
                        .buttonStyle(.borderedProminent)
                    }
                }
                .padding(14)
                .frame(width: 290, alignment: .leading)
                .background(.regularMaterial, in: RoundedRectangle(cornerRadius: 18))
                .padding(18)
            }
        } else {
            ContentUnavailableView(
                "没有找到 cod.pet 仓库",
                systemImage: "folder.badge.questionmark",
                description: Text("新的 hybrid app 需要在仓库目录内运行，才能直接复用现有展示页。")
            )
        }
    }
}

struct InstalledTabView: View {
    @EnvironmentObject private var store: CodpetHybridStore
    
    private let columns = [
        GridItem(.adaptive(minimum: 220, maximum: 260), spacing: 16)
    ]
    
    var body: some View {
        Group {
            if store.installedPets.isEmpty {
                ContentUnavailableView(
                    "还没有本地 Pet",
                    systemImage: "pawprint",
                    description: Text("你可以在“发现”页里直接安装，也可以导入自己本地已有的 Pet 文件夹。")
                )
            } else {
                ScrollView {
                    HStack {
                        Text("本地 Pet")
                            .font(.title2.weight(.semibold))
                        Spacer()
                        Button("导入本地 Pet") {
                            store.importPetFromFolder()
                        }
                        .buttonStyle(.bordered)
                        
                        Button("打开 Pet 文件夹") {
                            store.revealCodexPetsFolder()
                        }
                        .buttonStyle(.borderedProminent)
                    }
                    .padding(.horizontal, 20)
                    .padding(.top, 18)
                    
                    LazyVGrid(columns: columns, spacing: 16) {
                        ForEach(store.installedPets) { pet in
                            InstalledPetCard(pet: pet)
                        }
                    }
                    .padding(20)
                }
            }
        }
        .navigationTitle("已安装")
    }
}

struct InstalledPetCard: View {
    @EnvironmentObject private var store: CodpetHybridStore
    let pet: InstalledPet
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            ZStack(alignment: .topTrailing) {
                RoundedRectangle(cornerRadius: 16)
                    .fill(Color(NSColor.windowBackgroundColor))
                    .frame(height: 160)
                
                if let imageURL = pet.previewImageURL, let image = NSImage(contentsOf: imageURL) {
                    Image(nsImage: image)
                        .resizable()
                        .interpolation(.none)
                        .scaledToFit()
                        .frame(height: 120)
                        .frame(maxWidth: .infinity, maxHeight: .infinity)
                } else {
                    Image(systemName: "questionmark.square.dashed")
                        .font(.system(size: 40))
                        .foregroundColor(.secondary)
                        .frame(maxWidth: .infinity, maxHeight: .infinity)
                }
                
                if store.activePetSlug == pet.slug {
                    Text("当前使用中")
                        .font(.caption2.weight(.bold))
                        .padding(.horizontal, 8)
                        .padding(.vertical, 4)
                        .background(Color.green.opacity(0.16))
                        .clipShape(Capsule())
                        .padding(10)
                }
            }
            
            VStack(alignment: .leading, spacing: 6) {
                Text(pet.displayName)
                    .font(.headline)
                    .lineLimit(1)
                
                Text(pet.description)
                    .font(.caption)
                    .foregroundColor(.secondary)
                    .lineLimit(3)
            }
            
            HStack(spacing: 8) {
                if store.activePetSlug == pet.slug {
                    Button("已应用") {}
                        .buttonStyle(.bordered)
                        .disabled(true)
                        .frame(maxWidth: .infinity)
                } else {
                    Button("应用到 Codex") {
                        _ = store.applyPet(slug: pet.slug)
                    }
                    .buttonStyle(.borderedProminent)
                    .frame(maxWidth: .infinity)
                }
                
                Button {
                    store.uninstallPet(slug: pet.slug)
                } label: {
                    Image(systemName: "trash")
                }
                .buttonStyle(.bordered)
                .foregroundColor(.red)
            }
            
            Button("打开文件夹") {
                NSWorkspace.shared.activateFileViewerSelecting([pet.folderURL])
            }
            .buttonStyle(.plain)
            .font(.caption)
            .foregroundColor(.secondary)
        }
        .padding(14)
        .background(
            RoundedRectangle(cornerRadius: 18)
                .fill(store.activePetSlug == pet.slug ? Color.blue.opacity(0.08) : Color(NSColor.controlBackgroundColor))
        )
        .overlay(
            RoundedRectangle(cornerRadius: 18)
                .stroke(store.activePetSlug == pet.slug ? Color.blue.opacity(0.5) : Color.clear, lineWidth: 1)
        )
    }
}

struct HybridSettingsView: View {
    @EnvironmentObject private var store: CodpetHybridStore
    
    var body: some View {
        Form {
            Section("工作区") {
                LabeledContent("仓库目录") {
                    Text(store.repoRoot?.path ?? "Not found")
                        .foregroundColor(.secondary)
                        .textSelection(.enabled)
                }
                
                LabeledContent("Codex Pet 目录") {
                    Text(store.petsDir.path)
                        .foregroundColor(.secondary)
                        .textSelection(.enabled)
                }
                
                HStack(spacing: 12) {
                    Button("打开仓库目录") {
                        store.revealRepositoryRoot()
                    }
                    .buttonStyle(.bordered)
                    
                    Button("打开 Codex Pet 目录") {
                        store.revealCodexPetsFolder()
                    }
                    .buttonStyle(.bordered)
                    
                    Button("刷新全部状态") {
                        store.refreshAll()
                    }
                    .buttonStyle(.borderedProminent)
                }
            }
            
            Section("应用方式") {
                Picker("选择 Pet 后", selection: $store.applyMode) {
                    ForEach(CodexApplyMode.allCases) { mode in
                        Text(mode.title).tag(mode)
                    }
                }
                .pickerStyle(.radioGroup)
                
                Text(store.applyMode.subtitle)
                    .font(.caption)
                    .foregroundColor(.secondary)
            }
            
            Section("连接诊断") {
                Text("先用这里测试 Codex 当前窗口是否允许脚本注入；如果这一步不通，应用 pet 也不会即时生效。")
                    .font(.caption)
                    .foregroundColor(.secondary)
                
                HStack(spacing: 12) {
                    Button("测试 Codex 应用桥") {
                        store.diagnoseCodexBridge()
                    }
                    .buttonStyle(.borderedProminent)
                    
                    Button("打开 Codex") {
                        let configuration = NSWorkspace.OpenConfiguration()
                        configuration.activates = true
                        NSWorkspace.shared.openApplication(
                            at: URL(fileURLWithPath: "/Applications/Codex.app"),
                            configuration: configuration,
                            completionHandler: nil
                        )
                    }
                    .buttonStyle(.bordered)
                }
            }
            
            Section("说明") {
                Text("这版 hybrid app 保留了现有 `cod.pet` 的展示体验，同时把本地安装、删除、应用这些动作接回了 macOS 原生层。")
                    .font(.caption)
                    .foregroundColor(.secondary)
                Text("当前版本会定时同步 `~/.codex/config.toml` 和本地 Pet 目录，所以你在 Codex 里手动切换后，这里也会很快反映出来。")
                    .font(.caption)
                    .foregroundColor(.secondary)
                Text("如果你选择“尝试即时刷新”，app 会优先请求 Codex 自己应用 `selected-avatar-id`。第一次使用时，macOS 可能会要求你允许这个 app 控制 Codex。")
                    .font(.caption)
                    .foregroundColor(.secondary)
            }
        }
        .formStyle(.grouped)
        .padding(.top, 12)
        .navigationTitle("设置")
    }
}

struct CodpetWebStoreView: NSViewRepresentable {
    @EnvironmentObject private var store: CodpetHybridStore
    let pageURL: URL
    let readAccessRoot: URL
    
    func makeCoordinator() -> Coordinator {
        Coordinator(store: store)
    }
    
    func makeNSView(context: Context) -> WKWebView {
        let contentController = WKUserContentController()
        contentController.add(context.coordinator, name: "codpetNative")
        contentController.addUserScript(
            WKUserScript(
                source: injectedBridgeScript,
                injectionTime: .atDocumentStart,
                forMainFrameOnly: true
            )
        )
        
        let configuration = WKWebViewConfiguration()
        configuration.userContentController = contentController
        
        let webView = WKWebView(frame: .zero, configuration: configuration)
        webView.navigationDelegate = context.coordinator
        webView.setValue(false, forKey: "drawsBackground")
        webView.loadFileURL(pageURL, allowingReadAccessTo: readAccessRoot)
        return webView
    }
    
    func updateNSView(_ webView: WKWebView, context: Context) {
        context.coordinator.store = store
        context.coordinator.syncInstalledState(in: webView)
    }
    
    private var injectedBridgeScript: String {
        """
        (function() {
          if (window.__codpetNativeInjected) return;
          window.__codpetNativeInjected = true;

          const downloadIcon = `<svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2.5" stroke-linecap="round" stroke-linejoin="round" style="width:12px;height:12px;"><path d="M21 15v4a2 2 0 0 1-2 2H5a2 2 0 0 1-2-2v-4"></path><polyline points="7 10 12 15 17 10"></polyline><line x1="12" y1="15" x2="12" y2="3"></line></svg>`;
          const trashIcon = `<svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2.5" stroke-linecap="round" stroke-linejoin="round" style="width:12px;height:12px;"><polyline points="3 6 5 6 21 6"></polyline><path d="M19 6v14a2 2 0 0 1-2 2H7a2 2 0 0 1-2-2V6m3 0V4a2 2 0 0 1 2-2h4a2 2 0 0 1 2 2v2"></path><line x1="10" y1="11" x2="10" y2="17"></line><line x1="14" y1="11" x2="14" y2="17"></line></svg>`;

          const style = document.createElement("style");
          style.textContent = `
            body {
              user-select: none;
            }
            .header, .footer {
              display: none !important;
            }
            main.shell {
              padding-top: 16px !important;
            }
            .tile-dl {
              display: none !important;
            }
            .tile-name {
              display: block !important;
            }
            
            /* Installed: colorful static image */
            .tile.native-installed .sprite-static-gray {
              filter: grayscale(0%) !important;
              opacity: 1 !important;
            }
            .tile.native-installed .sprite-static-color {
              clip-path: inset(0% 0 0 0) !important;
            }
            
            /* Active desktop companion highlight */
            .tile.native-active {
              border: 2px solid #339cff !important;
              box-shadow: 0 0 12px rgba(51, 156, 255, 0.22) !important;
              background: rgba(51, 156, 255, 0.02) !important;
            }
            .tile.native-active::after {
              content: "Using";
              position: absolute;
              top: 8px;
              left: 8px;
              background: #339cff;
              color: #fff;
              font-size: 9px;
              font-weight: 700;
              padding: 2px 6px;
              border-radius: 99px;
              z-index: 5;
              text-transform: uppercase;
              letter-spacing: 0.05em;
            }
            
            /* Action Button on top-right (Delete/Download) */
            .app-action-btn {
              position: absolute;
              top: 8px;
              right: 8px;
              width: 24px;
              height: 24px;
              border-radius: 50%;
              background: #fff;
              border: 1px solid rgba(0, 0, 0, 0.1);
              display: flex;
              align-items: center;
              justify-content: center;
              color: rgba(0, 0, 0, 0.5);
              opacity: 0;
              transform: scale(0.9);
              transition: opacity 150ms ease, transform 150ms ease, background 150ms ease;
              z-index: 10;
              box-shadow: 0 2px 6px rgba(0,0,0,0.06);
              cursor: pointer;
            }
            .tile:hover .app-action-btn {
              opacity: 1;
              transform: scale(1);
            }
            .app-action-btn:hover {
              background: #f0f0f0;
              color: #000;
            }
            .app-action-btn.delete-btn {
              color: #ff3b30;
              border-color: rgba(255, 59, 48, 0.2);
            }
            .app-action-btn.delete-btn:hover {
              background: rgba(255, 59, 48, 0.08);
              color: #ff3b30;
            }
            
            /* NEW badge styling */
            .tile.is-new-pet::before {
              content: "NEW";
              position: absolute;
              top: 8px;
              left: 8px;
              background: #ff9500;
              color: #fff;
              font-size: 9px;
              font-weight: 700;
              padding: 2px 6px;
              border-radius: 99px;
              z-index: 5;
              text-transform: uppercase;
              letter-spacing: 0.05em;
              transition: opacity 300ms ease;
            }
            .tile.native-active.is-new-pet::before {
              display: none !important;
            }
          `;
          document.documentElement.appendChild(style);

          // NEW badge local tracker
          const SEEN_KEY = "codpet_seen_slugs";
          let seenSlugs = new Set(JSON.parse(localStorage.getItem(SEEN_KEY) || "[]"));
          
          window.updateNewBadges = function() {
            const tiles = document.querySelectorAll(".tile");
            if (tiles.length === 0) return;
            
            if (seenSlugs.size === 0) {
              // First run: mark all current pets as seen
              const allSlugs = Array.from(tiles).map(t => t.dataset.slug);
              seenSlugs = new Set(allSlugs);
              localStorage.setItem(SEEN_KEY, JSON.stringify(Array.from(seenSlugs)));
            } else {
              tiles.forEach(tile => {
                const slug = tile.dataset.slug;
                if (!seenSlugs.has(slug)) {
                  tile.classList.add("is-new-pet");
                }
              });
            }
          };

          // Hover listeners to clear NEW badge
          document.addEventListener("mouseenter", function(event) {
            const tile = event.target.closest(".tile");
            if (!tile) return;
            const slug = tile.dataset.slug;
            if (tile.classList.contains("is-new-pet")) {
              tile._seenTimeout = setTimeout(() => {
                tile.classList.remove("is-new-pet");
                seenSlugs.add(slug);
                localStorage.setItem(SEEN_KEY, JSON.stringify(Array.from(seenSlugs)));
              }, 1000);
            }
          }, true);

          document.addEventListener("mouseleave", function(event) {
            const tile = event.target.closest(".tile");
            if (!tile) return;
            if (tile._seenTimeout) {
              clearTimeout(tile._seenTimeout);
              delete tile._seenTimeout;
            }
          }, true);

          // Unified Click Router
          document.addEventListener("click", function(event) {
            const actionBtn = event.target.closest(".app-action-btn");
            const tile = event.target.closest(".tile");
            
            if (actionBtn) {
              event.preventDefault();
              event.stopPropagation();
              event.stopImmediatePropagation();
              
              const slug = actionBtn.dataset.slug;
              const action = actionBtn.dataset.action;
              
              window.webkit.messageHandlers.codpetNative.postMessage({
                type: action,
                slug: slug
              });
              return;
            }
            
            if (tile) {
              event.preventDefault();
              event.stopPropagation();
              event.stopImmediatePropagation();
              
              const slug = tile.dataset.slug;
              const isInstalled = tile.classList.contains("native-installed");
              
              window.webkit.messageHandlers.codpetNative.postMessage({
                type: isInstalled ? "apply" : "install",
                slug: slug
              });
            }
          }, true);

          window.codpetNativeSync = function(payload) {
            const installed = new Set((payload && payload.installed) || []);
            const active = payload && payload.active ? payload.active : "";
            
            // Check & draw NEW badges
            if (typeof window.updateNewBadges === "function") {
              window.updateNewBadges();
            }
            
            document.querySelectorAll(".tile").forEach((tile) => {
              const slug = tile.dataset.slug;
              const isInstalled = installed.has(slug);
              const isActive = slug === active;
              
              tile.classList.toggle("native-installed", isInstalled);
              tile.classList.toggle("native-active", isActive);
              
              let actionBtn = tile.querySelector(".app-action-btn");
              if (!actionBtn) {
                actionBtn = document.createElement("button");
                actionBtn.type = "button";
                actionBtn.className = "app-action-btn";
                tile.appendChild(actionBtn);
              }
              
              actionBtn.dataset.slug = slug;
              if (isInstalled) {
                actionBtn.className = "app-action-btn delete-btn";
                actionBtn.innerHTML = trashIcon;
                actionBtn.dataset.action = "uninstall";
                actionBtn.title = "Delete local pet";
              } else {
                actionBtn.className = "app-action-btn install-btn";
                actionBtn.innerHTML = downloadIcon;
                actionBtn.dataset.action = "install";
                actionBtn.title = "Install locally";
              }
            });
          };
        })();
        """
    }
    
    final class Coordinator: NSObject, WKNavigationDelegate, WKScriptMessageHandler {
        var store: CodpetHybridStore
        
        init(store: CodpetHybridStore) {
            self.store = store
        }
        
        func userContentController(_ userContentController: WKUserContentController, didReceive message: WKScriptMessage) {
            guard message.name == "codpetNative",
                  let body = message.body as? [String: Any],
                  let type = body["type"] as? String,
                  let slug = body["slug"] as? String else {
                return
            }
            
            switch type {
            case "install":
                store.installPet(slug: slug)
            case "apply":
                _ = store.applyPet(slug: slug)
            case "uninstall":
                store.uninstallPet(slug: slug)
            default:
                break
            }
        }
        
        func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
            syncInstalledState(in: webView)
        }
        
        func syncInstalledState(in webView: WKWebView) {
            let script = "window.codpetNativeSync && window.codpetNativeSync(\(store.installedSlugsJSON()))"
            webView.evaluateJavaScript(script)
        }
    }
}
