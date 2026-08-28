# my_app

## Standard file stru 

```text
lib/
│
├── main.dart
│
├── app/
│   ├── app.dart
│   ├── routes/
│   │   └── app_routes.dart
│   └── theme/
│       ├── app_theme.dart
│       ├── app_colors.dart
│       └── app_text_styles.dart
│
├── core/
│   ├── network/
│   │   ├── api_client.dart
│   │   └── api_endpoints.dart
│   │
│   ├── constants/
│   │   └── app_constants.dart
│   │
│   ├── errors/
│   │   └── app_exception.dart
│   │
│   └── utils/
│       └── validators.dart
│
├── features/
│   │
│   ├── auth/
│   │   ├── data/
│   │   │   ├── models/
│   │   │   │   ├── user_model.dart
│   │   │   │   └── login_response.dart
│   │   │   │
│   │   │   ├── services/
│   │   │   │   └── auth_service.dart
│   │   │   │
│   │   │   └── repositories/
│   │   │       └── auth_repository.dart
│   │   │
│   │   └── presentation/
│   │       ├── screens/
│   │       │   ├── login_screen.dart
│   │       │   └── register_screen.dart
│   │       │
│   │       ├── widgets/
│   │       │   └── login_form.dart
│   │       │
│   │       └── providers/
│   │           └── auth_provider.dart
│   │
│   └── products/
│       ├── data/
│       │   ├── models/
│       │   │   ├── product.dart
│       │   │   └── product_response.dart
│       │   │
│       │   ├── services/
│       │   │   └── product_service.dart
│       │   │
│       │   └── repositories/
│       │       └── product_repository.dart
│       │
│       └── presentation/
│           ├── screens/
│           │   └── product_screen.dart
│           │
│           ├── widgets/
│           │   └── product_card.dart
│           │
│           └── providers/
│               └── product_provider.dart
│
└── shared/
    ├── widgets/
    │   ├── custom_app_bar.dart
    │   ├── custom_button.dart
    │   └── custom_text_field.dart
    │
    └── extensions/
        └── context_extensions.dart
```

---

## `core/`

Things used throughout the entire application.

```text
core/
├── network/
├── constants/
├── errors/
└── utils/
```

### `Your API client belongs here:`

```dart
class ApiClient {
  // GET
  // POST
  // PUT
  // DELETE
}
```

### `And endpoints:`

```dart
class ApiEndpoints {
  static const products = "/products";
  static const login = "/auth/login";
}
```

---

## features/ ⭐

This is the most important part.

Each major functionality gets its own feature:

```text
features/
├── auth/
├── products/
├── orders/
├── profile/
└── cart/
```

This prevents your project from becoming:

```text
models/
  50 files

services/
  40 files

screens/
  70 files
```

Instead, everything related to a feature stays together.

---

## data/

Data/API-related code.

For example:

```text
products/
└── data/
    ├── models/
    ├── services/
    └── repositories/
```

### Model

```dart
class Product {
  final int id;
  final String title;
  final double price;

  Product({
    required this.id,
    required this.title,
    required this.price,
  });
}
```

### API service

```dart
class ProductService {
  Future<ProductResponse> getProducts() async {
    // API request
  }
}
```

### Repository

```dart
class ProductRepository {
  final ProductService service;

  ProductRepository(this.service);

  Future<ProductResponse> getProducts() {
    return service.getProducts();
  }
}
```

---

## presentation/

Everything related to displaying the feature.

```text
presentation/
├── screens/
├── widgets/
└── providers/
```

For example:

```text
products/
└── presentation/
    ├── screens/
    │   └── product_screen.dart
    │
    ├── widgets/
    │   └── product_card.dart
    │
    └── providers/
        └── product_provider.dart
```

---

## shared/

Reusable things that aren't specific to one feature.

For example:

```text
shared/
└── widgets/
    ├── custom_app_bar.dart
    ├── custom_button.dart
    ├── custom_text_field.dart
    └── loading_indicator.dart
```

Your reusable AppBar from earlier belongs here:

```text
shared/widgets/custom_app_bar.dart
```

---

## API flow

With this architecture, your product request flows like this:

```text
UI
 │
 ▼
Provider / State Management
 │
 ▼
Repository
 │
 ▼
Service
 │
 ▼
ApiClient
 │
 ▼
Backend API
 │
 ▼
JSON
 │
 ▼
Model
 │
 ▼
Repository
 │
 ▼
Provider
 │
 ▼
UI
```
