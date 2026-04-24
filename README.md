<p align="center">
  <img src="./Group_Copy_2_3x.png" alt="BudgetBloom Logo" width="120" />
</p>

# BudgetBloom — Spending Tracker

A minimal, privacy-first expense tracker for iPhone. Built to give users clarity on their spending without the noise of traditional budgeting apps.

[![App Store](https://img.shields.io/badge/Download_on_the-App_Store-black?style=flat&logo=apple)](https://apps.apple.com/us/app/budgetbloom-spending-tracker/id6737521957)
![Platform](https://img.shields.io/badge/Platform-iOS_17%2B-blue)
![Swift](https://img.shields.io/badge/Swift-5.9-orange?logo=swift)
![License](https://img.shields.io/badge/License-Proprietary-lightgrey)

---

## Overview

BudgetBloom is a lightweight expense tracker designed for people who want to understand their spending without being overwhelmed. All data stays on-device. No accounts, no servers, no ads.

---

## Features

- **Spending at a Glance** — View expenses by day, week, month, or year
- **Visual Insights** — Donut charts built with Swift Charts for quick category breakdowns
- **Siri Integration** — Query spending totals via App Intents (daily, weekly, monthly, YTD)
- **CSV Export** — Export all spending data for backup or analysis
- **Dark Mode** — Full dark mode support
- **Privacy First** — All data stored locally on-device; nothing collected or transmitted
- **Tip Jar** — Optional one-time tips via StoreKit to support development
- **Accessibility** — Supports Reduce Motion (disables chart animations), Dynamic Type, and Dark Interface

---

## Tech Stack

| Layer | Technology |
|---|---|
| UI & Charts | SwiftUI, Swift Charts |
| Persistence | SwiftData |
| Sync | CloudKit |
| Siri / Shortcuts | App Intents |
| In-App Purchases | StoreKit 2 |
| Accessibility | Reduce Motion, Dynamic Type, Dark Interface |
| Dependencies | [Swift Collections](https://github.com/apple/swift-collections) |

---

## Requirements

- iOS 17.0+
- Xcode 15+
- Swift 5.9+
- An Apple Developer account (for CloudKit entitlements)

---

## Installation

1. Clone the repo
   ```bash
   git clone https://github.com/your-username/BudgetBloom.git
   ```
2. Open `BudgetBloom.xcodeproj` in Xcode
3. Resolve Swift Package dependencies (Swift Collections will be fetched automatically)
4. Set your development team under **Signing & Capabilities**
5. Build and run on a simulator or device

> **Note:** CloudKit sync requires a physical device and an active iCloud account. It will not work on the simulator.

---

## Siri Commands

BudgetBloom supports the following App Intents phrases:

```
"What's my spending today in BudgetBloom?"
"What's my spending this week in BudgetBloom?"
"What's my spending this month in BudgetBloom?"
"What's my year to date spending in BudgetBloom?"
```

---

## Privacy

BudgetBloom does not collect any user data. All financial data is stored locally via SwiftData and optionally synced across a user's own devices via CloudKit. No analytics, no tracking, no third-party data sharing.

See the full [Privacy Policy](https://bmware93.github.io/BudgetBloom/).

---

## App Store

[Download BudgetBloom on the App Store](https://apps.apple.com/us/app/budgetbloom-spending-tracker/id6737521957)

---

## Developer

Built by **Benia Morgan-Ware** / WareNex Technologies LLC

Have feedback or a feature request? Use the in-app feedback option or open an issue.

