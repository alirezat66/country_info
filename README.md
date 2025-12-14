# Country Info - Flutter Mobile Application

## 🚀 Project Overview


**Country Info** is a simple Flutter mobile application designed to provide list of all countries and some info about each country. The goal of this project is implementing clean architecture using riverpod, graphql and go-router together.

## 📚 My Development Journey (Very Very Important)
This document focuses on the technical implementation, architecture, and code decision making process, so if firstly I do something and then change my decision it would represented in this document, why? I want develop document to walk trough the code reviewer in this journey, so the reviewer could know me more.
If you're interested in understanding my personal development journey, the challenges I faced, time management, and my decision-making process throughout this project, please refer to:
**[My Development Journey](DEVELOPMENT_JOURNEY.md)**

## Some Info About the Project

[![Dart](https://img.shields.io/badge/Dart-0175C2?style=for-the-badge&logo=dart&logoColor=white)](https://dart.dev/)
[![Flutter](https://img.shields.io/badge/Flutter-02569B?style=for-the-badge&logo=flutter&logoColor=white)](https://flutter.dev/)


### 🎯 Key Features
- **GraphQL Integration**: Fetching country data from GraphQL API with type-safe queries
- **Clean Architecture**: Feature-based modular structure with clear separation of concerns
- **Scalable State Management**: Using Riverpod for predictable state management
- **Type-Safe Navigation**: GoRouter implementation with deep linking support
- **Comprehensive Testing**: 349 tests (325 unit + 24 integration) with 100% pass rate
- **Hero Animations**: Smooth transitions between list and detail screens
- **Error Handling**: Robust error handling with retry functionality
- **Responsive UI**: Adaptive design for different screen sizes

---

## 🏗️ Architecture Overview

This project follows **Clean Architecture** principles with a feature-based organization pattern.

```
┌─────────────────────────────────────────────────────────────┐
│                    Presentation Layer                       │
│  ┌─────────────────┐  ┌─────────────────┐  ┌─────────────┐ │
│  │    Providers    │  │     Views       │  │   Widgets   │ │
│  │   (Riverpod)    │  │   (Screens)     │  │  (Reusable) │ │
│  └─────────────────┘  └─────────────────┘  └─────────────┘ │
└─────────────────────────────────────────────────────────────┘
                            ↓
┌─────────────────────────────────────────────────────────────┐
│                     Domain Layer                            │
│  ┌─────────────────┐  ┌─────────────────┐  ┌─────────────┐ │
│  │    Entities     │  │   Use Cases     │  │ Repositories│ │
│  │   (Business)    │  │   (Business     │  │ (Interfaces)│ │
│  │                 │  │     Logic)      │  │             │ │
│  └─────────────────┘  └─────────────────┘  └─────────────┘ │
└─────────────────────────────────────────────────────────────┘
                            ↓
┌─────────────────────────────────────────────────────────────┐
│                      Data Layer                             │
│  ┌─────────────────┐  ┌─────────────────┐  ┌─────────────┐ │
│  │   Repositories  │  │  Data Sources   │  │    Models   │ │
│  │ (Implementation)│  │   (GraphQL)     │  │  (Freezed)  │ │
│  └─────────────────┘  └─────────────────┘  └─────────────┘ │
└─────────────────────────────────────────────────────────────┘
```

---

## 📦 Package Selection & Technical Decisions

### **Core Dependencies**

| Package | Version | Purpose | Why Chosen |
|---------|---------|---------|------------|
| **flutter_riverpod** | ^3.0.3 | State Management | Modern, compile-safe, excellent testing support, minimal boilerplate |
| **graphql** | ^5.2.3 | GraphQL Client | Type-safe API queries, caching support, subscription ready |
| **go_router** | ^17.0.1 | Navigation | Declarative routing, deep linking, type-safe navigation |
| **freezed** | ^3.2.3 | Code Generation | Immutable data classes, union types, copyWith, equality |
| **json_serializable** | ^6.8.0 | JSON Serialization | Type-safe JSON parsing with code generation |
| **equatable** | ^2.0.7 | Value Equality | Simplified equality comparisons for entities |

### **Development Dependencies**

| Package | Version | Purpose | Why Chosen |
|---------|---------|---------|------------|
| **build_runner** | ^2.10.4 | Code Generation | Generates freezed, json_serializable, and mockito code |
| **mockito** | ^5.6.1 | Testing | Mock generation for unit tests |
| **patrol** | ^4.0.1 | Integration Testing | Native automation, real device testing, better than flutter_driver |
| **flutter_lints** | ^6.0.0 | Code Quality | Enforces Flutter best practices |

---

## 📂 Project Structure

### **Core Architecture**
```
lib/
├── core/                           # Shared infrastructure
│   ├── data/                      # Shared data layer
│   │   ├── consts/                # GraphQL queries and constants
│   │   ├── error/                 # Exception handling
│   │   └── network/               # Network layer
│   │       └── api/               # GraphQL API client
│   ├── domain/                    # Shared domain logic
│   │   ├── failure.dart           # Failure types
│   │   ├── result.dart            # Result wrapper pattern
│   │   └── usecase.dart           # Base use case interfaces
│   └── presentation/              # Shared UI components
│       ├── router/                # GoRouter configuration
│       ├── views/                 # Reusable views (Loading, Error, Empty)
│       ├── widgets/               # Reusable widgets (HeroText)
│       └── providers/             # Core providers
```

### **Feature-Based Organization**
```
lib/features/
└── country/                        # Country feature module
    ├── data/                      # Data layer
    │   ├── datasource/            # GraphQL data sources
    │   │   ├── country_datasource.dart          # Interface
    │   │   └── country_remote_datasource.dart   # Implementation
    │   ├── models/                # Data models (Freezed)
    │   │   ├── country_model.dart              # Country DTO
    │   │   ├── continent_model.dart            # Continent DTO
    │   │   └── language_model.dart             # Language DTO
    │   └── repository/            # Repository implementations
    │       └── country_repository_impl.dart
    ├── domain/                    # Business logic layer
    │   ├── entities/              # Domain entities
    │   │   ├── country.dart                    # Country entity
    │   │   ├── continent.dart                  # Continent entity
    │   │   ├── language.dart                   # Language entity
    │   │   └── country_mapper_ext.dart         # Entity extensions
    │   ├── repository/            # Repository interfaces
    │   │   └── country_repository.dart
    │   └── usecases/              # Business use cases
    │       ├── get_countries.dart              # Fetch all countries
    │       └── get_country_details.dart        # Fetch country details
    └── presentation/              # UI layer
        ├── providers/             # Riverpod providers
        │   ├── country_providers.dart          # Feature providers
        │   ├── country_datasource_provider.dart
        │   ├── country_repository_provider.dart
        │   ├── country_usecase_provider.dart
        │   ├── show_more_notifier.dart         # State notifier
        │   └── show_more_provider.dart         # Provider definition
        └── views/                 # UI implementation
            ├── country_list/      # List screen
            │   ├── list_screen.dart            # Main screen
            │   └── views/                      # View components
            │       ├── country_list_view.dart
            │       └── loaded_view.dart
            ├── country_detail/    # Detail screen
            │   ├── detail_screen.dart          # Main screen
            │   └── views/                      # View components
            │       └── detail_view.dart
            └── widgets/           # Feature widgets
                ├── country_list_item.dart      # List item widget
                └── country_detail_item.dart    # Detail item widget
```

### **Key Benefits of This Structure**
- **Scalability**: Easy to add new features without affecting existing code
- **Maintainability**: Clear separation of concerns, easy to locate code
- **Testability**: Isolated components enable comprehensive testing
- **Team Collaboration**: Multiple developers can work on different features simultaneously
- **Code Reusability**: Shared components in core layer prevent duplication

---

## 🔄 Data Flow Architecture

### **Request Flow**
```
User Interaction
      ↓
[Presentation Layer]
  Widget → Provider → Use Case
      ↓
[Domain Layer]
  Use Case → Repository Interface
      ↓
[Data Layer]
  Repository Impl → DataSource → GraphQL API
      ↓
  Response (JSON) → Model → Entity
      ↓
[Back to Presentation]
  Result<Entity> → Provider → Widget Update
```

### **State Management Flow (Riverpod)**
```
┌─────────────────────────────────────────────────────────────┐
│                    Provider Hierarchy                       │
├─────────────────────────────────────────────────────────────┤
│  GraphQL Client Provider                                    │
│           ↓                                                 │
│  DataSource Provider                                        │
│           ↓                                                 │
│  Repository Provider                                        │
│           ↓                                                 │
│  UseCase Provider                                           │
│           ↓                                                 │
│  Feature Provider (FutureProvider/NotifierProvider)         │
│           ↓                                                 │
│  UI Widgets (ConsumerWidget)                                │
└─────────────────────────────────────────────────────────────┘
```

---

## 🧪 Testing Strategy

### **Test Coverage: 349 Total Tests (100% Pass Rate)**

#### **Unit Tests: 325 tests**

**Data Layer (89 tests):**
- ✅ Model serialization/deserialization (CountryModel, ContinentModel, LanguageModel)
- ✅ DataSource methods with GraphQL queries
- ✅ Repository implementations with error handling
- ✅ GraphQL query validation

**Domain Layer (70 tests):**
- ✅ Use cases (GetCountries, GetCountryDetails)
- ✅ Entity extensions (CountryMapperExt)
- ✅ Result pattern handling
- ✅ Failure types

**Presentation Layer (111 tests):**
- ✅ State management (ShowMoreNotifier)
- ✅ All widgets (CountryListItem, CountryDetailItem)
- ✅ All views (DetailView, CountryListView, LoadedView)
- ✅ All screens (ListScreen, DetailScreen)

**Core Layer (55 tests):**
- ✅ Reusable widgets (HeroText)
- ✅ Common views (LoadingView, ErrorView, EmptyView)
- ✅ GraphQL client and error handling

#### **Integration Tests: 24 patrol tests**

**List Screen (9 tests):**
- ✅ Display countries list
- ✅ Loading states
- ✅ Error handling and retry
- ✅ Empty states
- ✅ Scrolling and interactions
- ✅ Navigation to detail

**Detail Screen (15 tests):**
- ✅ Navigation flows
- ✅ Data loading and display
- ✅ Show more/less functionality
- ✅ Error handling
- ✅ Edge cases (null fields, multiple languages, RTL)
- ✅ State management across navigation

### **Test File Structure**
```
test/
├── core/                          # Core layer tests
│   ├── data/                      # Data utilities tests
│   │   ├── consts/                # Query validation tests
│   │   └── network/               # Network layer tests
│   ├── domain/                    # Domain utilities tests
│   └── presentation/              # Core widget tests
│       ├── views/                 # Common view tests
│       └── widgets/               # Reusable widget tests
└── features/
    └── country/                   # Country feature tests
        ├── data/                  # Data layer tests
        │   ├── datasource/        # DataSource tests
        │   ├── models/            # Model tests
        │   └── repository/        # Repository tests
        ├── domain/                # Domain layer tests
        │   ├── entities/          # Entity extension tests
        │   └── usecases/          # Use case tests
        └── presentation/          # Presentation layer tests
            ├── providers/         # Provider tests
            └── views/             # Widget/screen tests

integration_test/                  # Patrol integration tests
├── detail_screen_test.dart        # Detail page E2E tests
├── list_screen_test.dart          # List page E2E tests
└── test_bundle.dart               # Test bundle configuration
```

---

## 🎨 Design Patterns & Best Practices

### **1. Repository Pattern**
Abstracts data sources and provides a clean API for the domain layer.

```dart
// Interface in domain layer
abstract class CountryRepository {
  Future<Result<List<Country>>> getCountries();
  Future<Result<Country>> getCountryDetails(String code);
}

// Implementation in data layer
class CountryRepositoryImpl implements CountryRepository {
  final CountryDataSource remoteDataSource;
  // Implementation with error handling
}
```

### **2. Sealed Pattern**
Type-safe error handling without exceptions.

```dart
sealed class Result<T> {
  const Result();
  
  R fold<R>({
    required R Function(Failure failure) onFailure,
    required R Function(T value) onSuccess,
  });
}

class Success<T> extends Result<T> { /* ... */ }
class FailureResult<T> extends Result<T> { /* ... */ }
```

### **3. Use Case Pattern (Command Design Pattern)**
Encapsulates business logic in single-responsibility classes.

```dart
abstract class UseCase<T> {
  Future<Result<T>> call();
}

abstract class UseCaseWithParams<T, P> {
  Future<Result<T>> call(P params);
}
```

### **4. Provider Pattern (Riverpod)**
Dependency injection and state management.

```dart
// Provider hierarchy
final apiClientProvider = Provider<GraphQLApiClient>(...);
final dataSourceProvider = Provider<CountryDataSource>(...);
final repositoryProvider = Provider<CountryRepository>(...);
final useCaseProvider = Provider<GetCountries>(...);
final countriesProvider = FutureProvider<List<Country>>(...);
```


---

## 📚 Key Technical Implementations

### **1. GraphQL Integration**

**Query Management:**
- Centralized queries in `lib/core/data/consts/const_queries.dart`
- Type-safe query execution with error handling
- Variable support for parameterized queries

```dart
class ConstQueries {
  static const String getCountriesQuery = '''
    query GetCountries {
      countries {
        code
        name
        emoji
      }
    }
  ''';
  
  static const String getCountryDetailsQuery = '''
    query GetCountryDetails($code: ID!) {
      country(code: $code) {
        code
        name
        emoji
        capital
        currency
        phone
        continent { code name }
        languages { code name native rtl }
      }
    }
  ''';
}
```

### **2. Error Handling**

**Three-Layer Error Handling:**

1. **Data Layer**: Catches exceptions and converts to domain failures
2. **Domain Layer**: Uses Result pattern for type-safe error propagation
3. **Presentation Layer**: Displays appropriate UI based on error type

```dart
// Exception types
class ServerException implements Exception { /* ... */ }
class NetworkException implements Exception { /* ... */ }

// Failure types
sealed class Failure {
  final String message;
  final String? code;
}

class ServerFailure extends Failure { /* ... */ }
class NetworkFailure extends Failure { /* ... */ }
```

### **3. State Management with Riverpod**

**Provider Types Used:**
- `Provider`: For dependencies (repositories, use cases)
- `FutureProvider`: For async data fetching
- `FutureProvider.family`: For parameterized async data
- `NotifierProvider`: For mutable state (ShowMoreNotifier)

**Example:**
```dart
// Dependency provider
final getCountryDetailsProvider = Provider<GetCountryDetails>((ref) {
  return GetCountryDetails(ref.watch(countriesRepositoryProvider));
});

// Data provider with parameter
final countryDetailsProvider = FutureProvider.family<Country, String>((
  ref,
  code,
) async {
  final useCase = ref.watch(getCountryDetailsProvider);
  final result = await useCase(code);
  return result.fold(
    (failure) => throw failure,
    (country) => country,
  );
});

// State notifier
final showMoreProvider = NotifierProvider.autoDispose<ShowMoreNotifier, bool>(
  ShowMoreNotifier.new,
);
```

### **4. Navigation with GoRouter**

**Route Configuration:**
```dart
final appRouter = GoRouter(
  initialLocation: '/countries',
  routes: [
    GoRoute(
      path: '/countries',
      builder: (context, state) => const ListScreen(),
      routes: [
        GoRoute(
          path: ':code',
          builder: (context, state) {
            final code = state.pathParameters['code']!;
            final countryName = state.extra as String?;
            return DetailScreen(
              countryCode: code,
              countryName: countryName,
            );
          },
        ),
      ],
    ),
  ],
);
```

### **5. Extension Methods for Business Logic**

**CountryMapperExt:**
```dart
extension CountryMapperExt on Country {
  // Basic fields for initial display
  Map<String, String> get basicFields => {
    'Flag': emoji,
    'Name': name,
    'Code': code,
    'Capital': capital ?? '',
  };
  
  // Extended fields for detailed view
  Map<String, String> get extendedFields => {
    ...basicFields,
    'Currency': currency ?? 'NA',
    'Phone': phone ?? 'AN',
    'Continent Code': continent?.code ?? 'NA',
    if (continent != null) 'Continent Name': continent!.name,
    if (languages.isNotEmpty)
      'Languages': languages.map((l) => l.name).join(', '),
  };
}
```

---

## 🧪 Testing Approach

### **Testing Philosophy**
- **Test Pyramid**: More unit tests, fewer integration tests
- **Behavior Testing**: Test what the code does, not how it does it
- **Arrange-Act-Assert**: Clear test structure with comments
- **Mock External Dependencies**: Use Mockito for isolation
- **Real Integration Tests**: Use Patrol for E2E testing

### **Running Tests**

```bash
# Run all unit tests
flutter test

# Run specific test file
flutter test test/features/country/domain/usecases/get_countries_test.dart

# Run with coverage
flutter test --coverage

# Run integration tests with Patrol
patrol test

# Run on specific device
patrol test --device <device-id>

# Run specific integration test
patrol test --target integration_test/detail_screen_test.dart
```

### **Test Patterns**

**Unit Test Example:**
```dart
@GenerateMocks([CountryRepository])
void main() {
  late GetCountries useCase;
  late MockCountryRepository mockRepository;

  setUp(() {
    mockRepository = MockCountryRepository();
    useCase = GetCountries(mockRepository);
  });

  test('should return success with countries', () async {
    // arrange
    final countries = [/* ... */];
    when(mockRepository.getCountries())
        .thenAnswer((_) async => Result.success(countries));

    // act
    final result = await useCase();

    // assert
    expect(result, isA<Success<List<Country>>>());
    verify(mockRepository.getCountries()).called(1);
  });
}
```

**Widget Test Example:**
```dart
testWidgets('should display country details', (tester) async {
  // arrange & act
  await tester.pumpWidget(
    MaterialApp(
      home: Scaffold(
        body: CountryDetailItem(
          label: 'Capital',
          value: 'Washington, D.C.',
        ),
      ),
    ),
  );

  // assert
  expect(find.text('Capital:'), findsOneWidget);
  expect(find.text('Washington, D.C.'), findsOneWidget);
});
```

**Patrol Test Example:**
```dart
patrolTest('should navigate to detail page', ($) async {
  // arrange
  await $.pumpWidgetAndSettle(
    ProviderScope(
      overrides: [/* provider overrides */],
      child: const MyApp(),
    ),
  );

  // act
  await $.tap(find.text('United States'));
  await $.pumpAndSettle();

  // assert
  expect(find.text('Flag:'), findsOneWidget);
  expect(find.text('Capital:'), findsOneWidget);
});
```

---

## 🚀 Getting Started

### **Prerequisites**
- Flutter SDK: ^3.10.3
- Dart SDK: ^3.10.3
- Android Studio / Xcode for mobile development
- Patrol CLI for integration testing

### **Installation**

1. **Clone the repository**
```bash
git clone <repository-url>
cd country_info
```

2. **Install dependencies**
```bash
flutter pub get
```

3. **Generate code (Freezed, JSON, Mocks)**
```bash
flutter pub run build_runner build --delete-conflicting-outputs
```

4. **Run the app**
```bash
flutter run
```

### **Running Tests**

```bash
# Unit tests
flutter test

# Integration tests
patrol test

# Generate coverage report
flutter test --coverage
genhtml coverage/lcov.info -o coverage/html
open coverage/html/index.html
```

---

## 📱 Features Implemented

### **1. Country List Screen**
- Display all countries with flag, name, and navigation
- Loading states with CircularProgressIndicator
- Error handling with retry functionality
- Empty state handling
- Smooth scrolling for large lists
- Hero animation preparation

### **2. Country Detail Screen**
- Display country details with expandable sections
- Basic fields: Flag, Name, Code, Capital
- Extended fields: Currency, Phone, Continent, Languages
- Show More/Less toggle functionality
- Loading and error states
- Hero animation from list screen
- Back navigation support

### **3. Core Features**
- GraphQL API integration
- Offline-ready architecture (ready for caching)
- Error boundary with user-friendly messages
- Responsive design
- Material Design 3 theming

---

## 🔧 Code Generation

This project uses code generation for:

1. **Freezed**: Immutable data classes
2. **JSON Serializable**: JSON parsing
3. **Mockito**: Test mocks

**Generate code:**
```bash
flutter pub run build_runner build --delete-conflicting-outputs
```

**Watch mode (auto-generate on file changes):**
```bash
flutter pub run build_runner watch --delete-conflicting-outputs
```

---

## 📖 API Documentation

### **GraphQL Endpoint**
- **URL**: `https://countries.trevorblades.com/graphql`
- **Type**: Public GraphQL API
- **Documentation**: [Countries GraphQL API](https://github.com/trevorblades/countries)

### **Available Queries**

**Get All Countries:**
```graphql
query GetCountries {
  countries {
    code
    name
    emoji
  }
}
```

**Get Country Details:**
```graphql
query GetCountryDetails($code: ID!) {
  country(code: $code) {
    code
    name
    emoji
    capital
    currency
    phone
    continent { code name }
    languages { code name native rtl }
  }
}
```

---

## 🎯 Future Enhancements

- [ ] Implement search functionality
- [ ] Implement theme (Dark and Light)
- [ ] Support for multiple languages (i18n)
- [ ] Dark theme support
- [ ] Accessibility improvements
- [ ] Pagination for list of countries

---

## 📄 License

This project is created for test purposes.

---

## 👨‍💻 Author

**Reza Taghizadeh**

For more details about the development process, challenges, and decision-making, see [DEVELOPMENT_JOURNEY.md](DEVELOPMENT_JOURNEY.md)
