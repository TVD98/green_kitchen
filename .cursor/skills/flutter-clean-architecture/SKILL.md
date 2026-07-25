---
name: flutter-clean-architecture
description: >-
  Apply Clean Architecture + BLoC feature-first structure for Flutter apps.
  Use when creating features, scaffolding folders, implementing domain/data/presentation
  layers, BLoC, repositories, or Flutter CI/CD deployment.
---

# 🚀 Flutter Senior Skills: Clean Architecture & Deployment Guide

A standardized summary of project architecture (Clean Architecture + BLoC) and deployment roadmap (CI/CD) for Flutter applications.

---

## 🏛️ 1. Architecture Skill: Clean Architecture + BLoC

A feature-first structure divided into 3 independent layers. The dependency rule points strictly inwards: `Presentation` -> `Domain` <- `Data`.

### Standard Structure of a Feature (Feature-First)

```text
lib/features/[feature_name]/
├── domain/                  # [Pure Dart] Core business logic (No Flutter/Third-party dependencies)
│   ├── entities/            # Pure business models
│   ├── repositories/        # Interfaces / Contracts
│   └── usecases/            # Single business logic scenarios
├── data/                    # [Data Layer] Data source handling
│   ├── datasources/         # Remote (Dio/HTTP) or Local (Hive/SQLite)
│   ├── models/              # DTOs, JSON mapping (extends Entity)
│   └── repositories/        # Implementations of Domain Repositories
└── presentation/            # [UI Layer] UI Components and State Management
    ├── bloc/                # BLoC, Event, State
    ├── pages/               # Main screens/pages
    └── widgets/             # Reusable UI widgets