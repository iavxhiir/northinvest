# North Invest - App Store Publishing Guide

## 📱 App Icon Creation

### Option 1: Use the SwiftUI Preview (Recommended)
1. Open Xcode and navigate to `Resources/AppIconView.swift`
2. Open the Canvas preview (Editor → Canvas)
3. Choose your preferred design from the 3 previews
4. Take a screenshot at 1024x1024 resolution
5. Or use the iOS Simulator and screenshot the view

### Option 2: Use an AI Image Generator
Prompt for AI tools like Midjourney, DALL-E, or Ideogram:

```
Professional iOS app icon for "North Invest" - a financial accounting app. 
Dark navy blue background (#0f172a). 
Green (#10b981) and blue (#3b82f6) accent colors. 
Minimalist design with upward trending chart or growth arrow. 
Letters "NI" incorporated subtly. 
Clean, modern, professional financial aesthetic.
1024x1024, rounded corners, no text overlay.
```

### Option 3: Use Canva or Figma
- Size: 1024x1024 pixels
- Colors: Background #0f172a, Green #10b981, Blue #3b82f6
- Include: Growth chart, arrow up, or "NI" initials

### Adding the Icon to Xcode:
1. Create a 1024x1024 PNG image (no transparency, no alpha)
2. In Xcode, open `Assets.xcassets` → `AppIcon`
3. Drag your 1024x1024 image to the "iOS 1024pt" slot
4. Xcode will automatically generate all required sizes

---

## 🚀 App Store Publishing Steps

### Prerequisites
- [ ] Apple Developer Account ($99/year) - https://developer.apple.com/programs/enroll/
- [ ] Mac with Xcode installed
- [ ] App icon (1024x1024)
- [ ] Screenshots for all required device sizes

### Step 1: Prepare Your App

#### Update App Info in Xcode:
1. Select the project in Navigator
2. Select "NorthInvest" target
3. **General Tab:**
   - Display Name: `North Invest`
   - Bundle Identifier: `com.yourname.northinvest` (must be unique)
   - Version: `1.0.0`
   - Build: `1`
   - Deployment Target: iOS 17.0 (or lower for more compatibility)

4. **Signing & Capabilities Tab:**
   - Team: Select your Apple Developer team
   - Signing Certificate: Apple Distribution
   - Enable "Automatically manage signing"

### Step 2: Create App Store Connect Listing

1. Go to https://appstoreconnect.apple.com
2. Click "My Apps" → "+" → "New App"
3. Fill in:
   - **Platform:** iOS
   - **Name:** North Invest - Llogaritje Biznesi
   - **Primary Language:** Albanian (or English)
   - **Bundle ID:** Select your bundle ID
   - **SKU:** `northinvest001`

### Step 3: App Information

#### App Store Listing (Albanian):
```
Name: North Invest - Llogaritje Biznesi

Subtitle: Menaxho financat e biznesit

Description:
North Invest është aplikacioni ideal për menaxhimin e financave të biznesit tuaj. 

VEÇORITË KRYESORE:
• 💰 Regjistroni të ardhurat sipas shërbimit
• 💸 Ndiqni shpenzimet sipas kategorisë  
• 📄 Menaxhoni faturat dhe pagesat
• 👷 Llogaritni pagat e punonjësve
• 📊 Shikoni pasqyrën mujore dhe vjetore
• 📤 Eksportoni të dhënat në format CSV

KATEGORITË E SHËRBIMEVE:
- Transport Inertesh
- Gërmime
- Mjete me Qira
- Ngarkime

KATEGORITË E SHPENZIMEVE:
- Nafte, Goma, Vajra dhe Filtra
- Riparime Mekanike
- Siguracione dhe Taksa
- Pjesë Këmbimi

Të gjitha të dhënat ruhen automatikisht në pajisjen tuaj. Eksportoni raporte CSV për t'i hapur në Excel.

Krijuar posaçërisht për North Invest SHPK.

Keywords: llogaritje, biznes, finance, fatura, shpenzime, ardhura, paga, kontabilitet, raport

Category: Business (Primary), Finance (Secondary)
```

#### English Version:
```
Name: North Invest - Business Accounting

Subtitle: Manage your business finances

Description:
North Invest is the perfect app for managing your business finances.

KEY FEATURES:
• 💰 Record income by service type
• 💸 Track expenses by category
• 📄 Manage invoices and payments
• 👷 Calculate employee salaries
• 📊 View monthly and yearly overview
• 📤 Export data to CSV format

All data is saved automatically on your device. Export CSV reports to open in Excel.

Keywords: accounting, business, finance, invoice, expenses, income, salary, bookkeeping, report

Category: Business (Primary), Finance (Secondary)
```

### Step 4: Screenshots

Required sizes (take from Simulator):
- **6.7" iPhone** (iPhone 15 Pro Max): 1290 x 2796 pixels
- **6.5" iPhone** (iPhone 11 Pro Max): 1284 x 2778 pixels  
- **5.5" iPhone** (iPhone 8 Plus): 1242 x 2208 pixels

Recommended screenshots:
1. Dashboard/Panel view showing stats
2. Income (Ardhurat) list
3. Expenses (Shpenzimet) list
4. Invoices (Faturat) with payment tracking
5. Salaries (Pagat) grid
6. Export screen

### Step 5: Build and Upload

1. In Xcode: **Product → Archive**
2. Wait for archive to complete
3. In Organizer window: Click **Distribute App**
4. Select: **App Store Connect**
5. Select: **Upload**
6. Follow prompts and wait for upload

### Step 6: Submit for Review

1. Go to App Store Connect
2. Select your app
3. Click "+ Version or Platform" if needed
4. Fill in "What's New" section
5. Select your uploaded build
6. Answer export compliance (Usually "No" for encryption)
7. Click **Submit for Review**

---

## 📋 App Review Checklist

Before submitting, ensure:
- [ ] App icon is 1024x1024, no alpha/transparency
- [ ] All screenshots are correct sizes
- [ ] Privacy policy URL (required if collecting data)
- [ ] App works on all supported devices
- [ ] No placeholder content
- [ ] No crashes or bugs

## 🔒 Privacy Policy

Since the app only stores data locally, you can use a simple privacy policy:

```
North Invest Privacy Policy

North Invest does not collect, store, or share any personal data 
with third parties. All data entered in the app is stored locally 
on your device only.

Data Storage:
- All financial records are stored on your device
- Data is not transmitted to any server
- You can export your data as CSV files

Contact: your-email@example.com
Last updated: January 2026
```

Host this on a free site like GitHub Pages or Google Sites.

---

## ⏱ Timeline

- **App Review:** Usually 24-48 hours (can be up to 7 days)
- **After Approval:** App goes live within a few hours
- **Updates:** Follow same process, increment version number

## 💡 Tips

1. Start with a TestFlight beta first to test with real users
2. Respond quickly if Apple requests changes
3. Keep your developer account active ($99/year renewal)
4. Monitor crash reports in App Store Connect

---

Good luck with your app! 🚀
