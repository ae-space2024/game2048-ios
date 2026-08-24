import UIKit
import WebKit
import UniformTypeIdentifiers

class ViewController: UIViewController, UIDocumentPickerDelegate {

    private var webView: WKWebView!
    private var toolbar: UIToolbar!
    private var titleLabel: UILabel!

    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = UIColor(red: 0.06, green: 0.05, blue: 0.16, alpha: 1.0)
        overrideUserInterfaceStyle = .dark

        setupWebView()
        setupToolbar()
        setupTitleLabel()
        applyConstraints()
    }

    private func setupWebView() {
        let config = WKWebViewConfiguration()
        config.preferences.javaScriptCanOpenWindowsAutomatically = true
        config.allowsInlineMediaPlayback = true

        webView = WKWebView(frame: .zero, configuration: config)
        webView.isOpaque = false
        webView.backgroundColor = UIColor(red: 0.06, green: 0.05, blue: 0.16, alpha: 1.0)
        webView.scrollView.backgroundColor = UIColor(red: 0.06, green: 0.05, blue: 0.16, alpha: 1.0)
        webView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(webView)
    }

    private func setupToolbar() {
        toolbar = UIToolbar()
        toolbar.translatesAutoresizingMaskIntoConstraints = false
        toolbar.barTintColor = UIColor(red: 0.08, green: 0.07, blue: 0.20, alpha: 0.95)
        toolbar.isTranslucent = false

        let openItem = UIBarButtonItem(image: UIImage(systemName: "folder"), style: .plain, target: self, action: #selector(openFilePicker))
        openItem.tintColor = .systemBlue

        let reloadItem = UIBarButtonItem(image: UIImage(systemName: "arrow.clockwise"), style: .plain, target: self, action: #selector(reloadPage))
        reloadItem.tintColor = .systemBlue

        let backItem = UIBarButtonItem(image: UIImage(systemName: "chevron.left"), style: .plain, target: self, action: #selector(goBack))
        backItem.tintColor = .systemBlue

        let flexItem = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)

        let shareItem = UIBarButtonItem(image: UIImage(systemName: "square.and.arrow.up"), style: .plain, target: self, action: #selector(shareFile))
        shareItem.tintColor = .systemBlue

        toolbar.items = [flexItem, backItem, flexItem, reloadItem, flexItem, openItem, flexItem, shareItem, flexItem]
        view.addSubview(toolbar)
    }

    private func setupTitleLabel() {
        titleLabel = UILabel()
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        titleLabel.text = "HTML Viewer"
        titleLabel.textColor = UIColor.white.withAlphaComponent(0.9)
        titleLabel.font = UIFont.systemFont(ofSize: 15, weight: .medium)
        titleLabel.textAlignment = .center
        view.addSubview(titleLabel)
    }

    private func applyConstraints() {
        let safeTop = view.safeAreaLayoutGuide.topAnchor
        let safeBottom = view.safeAreaLayoutGuide.bottomAnchor

        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: safeTop, constant: 4),
            titleLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            titleLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            titleLabel.heightAnchor.constraint(equalToConstant: 22),

            webView.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 0),
            webView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            webView.trailingAnchor.constraint(equalTo: view.trailingAnchor),

            toolbar.topAnchor.constraint(equalTo: webView.bottomAnchor),
            toolbar.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            toolbar.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            toolbar.bottomAnchor.constraint(equalTo: safeBottom),
            toolbar.heightAnchor.constraint(equalToConstant: 44),
        ])
    }

    @objc private func openFilePicker() {
        let picker = UIDocumentPickerViewController(forOpeningContentTypes: [UTType.html, UTType.data])
        picker.delegate = self
        picker.allowsMultipleSelection = false
        picker.modalPresentationStyle = UIModalPresentationStyle.formSheet
        present(picker, animated: true)
    }

    @objc private func reloadPage() {
        webView.reload()
    }

    @objc private func goBack() {
        if webView.canGoBack { webView.goBack() }
    }

    @objc private func shareFile() {
        guard let url = webView.url else { return }
        let shareVC = UIActivityViewController(activityItems: [url], applicationActivities: nil)
        shareVC.popoverPresentationController?.barButtonItem = toolbar.items?.last
        present(shareVC, animated: true)
    }

    func openFile(url: URL) {
        let needsAccess = url.startAccessingSecurityScopedResource()
        defer { if needsAccess { url.stopAccessingSecurityScopedResource() } }

        let dir = url.deletingLastPathComponent()
        titleLabel.text = url.lastPathComponent
        webView.loadFileURL(url, allowingReadAccessTo: dir)
    }

    func documentPicker(_ controller: UIDocumentPickerViewController, didPickDocumentsAt urls: [URL]) {
        guard let url = urls.first else { return }
        openFile(url: url)
    }
}
