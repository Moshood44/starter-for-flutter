# 📱 TaskPay - Student Task Marketplace

TaskPay connects students who need tasks done with other students who want to earn money. Built with Flutter and Appwrite.

## 🚀 Quick Start

### 1. Clone and Install
```bash
git clone <your-repo-url>
cd taskpay
flutter pub get
```

### 2. Set Up Backend (5 minutes)
Follow our **super easy** setup guide: [docs/appwrite-setup.md](docs/appwrite-setup.md)

### 3. Configure Environment
1. Copy `.env.example` to `.env`
2. Add your Appwrite Project ID from step 2

### 4. Run the App
```bash
flutter run --dart-define-from-file=.env
```

## ✨ Features

- 🔐 **User Authentication** - Sign up as Poster or Tasker
- 👤 **User Profiles** - Manage your profile and ratings
- 📝 **Task Management** - Post and discover tasks
- 💬 **Real-time Chat** - Communicate with task partners
- 💳 **Secure Payments** - Escrow system with Paystack
- 🌙 **Dark/Light Theme** - Choose your preferred theme

## 🏗️ Architecture

```
lib/
├── data/           # Data layer (models, repositories, services)
├── ui/             # UI layer (screens, widgets, themes)
└── utils/          # Utilities and helpers
```

## 🧪 Testing

```bash
flutter test
```

## 📚 Documentation

- [Appwrite Setup Guide](docs/appwrite-setup.md) - Backend setup
- [API Documentation](docs/api.md) - API reference
- [Contributing Guide](CONTRIBUTING.md) - How to contribute

## 🤝 Contributing

1. Fork the repository
2. Create your feature branch (`git checkout -b feature/amazing-feature`)
3. Commit your changes (`git commit -m 'Add amazing feature'`)
4. Push to the branch (`git push origin feature/amazing-feature`)
5. Open a Pull Request

## 📄 License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

## 🆘 Support

- 📖 [Documentation](docs/)
- 🐛 [Report Issues](https://github.com/your-username/taskpay/issues)
- 💬 [Discussions](https://github.com/your-username/taskpay/discussions)

---

**Made with ❤️ by the TaskPay Team**