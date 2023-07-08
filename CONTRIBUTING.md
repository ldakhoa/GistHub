#

## 1. Cloning the repo

1. Tap the Fork button of this repo
2. `git clone https://github.com/YourGitHubUsername/GistHub.git`

## 2. Installing

Just open the `GistHub.xcodeproj` and waiting for dependencies load.

## 3. Setting up OAuth for login

You'll need to [register](https://github.com/settings/applications/new) new OAuth application.

### Registering

Make sure the Authorization callback URL is set to `gisthub://`. The others can be filled in as you wish.

You will be redirected to the application page where you can access your Client ID and Client Secret.

To add the Client ID and Client Secret to the App, follow these steps:

1. Open the GistHub/GistHub.xcodeproj file.
2. Go to Product > Scheme > Manage Schemes...
3. Select GistHub and click the cog.
4. Click on Duplicate.
5. Select Copy of GistHub and uncheck "Shared" checkbox, you can rename it as you want.
6. With 'Copy of GistHub' selected, click on Edit...
7. Go to Run > Arguments
8. Add your Client ID (`GITHUB_CLIENT_ID` as key) and Client Secret (`GITHUB_CLIENT_SECRET`) to the Environment Variables.

🎉 The project is officially set up! 🎉

# Modularization

## Add new Module

1. Create the new module by `swift Packages/PackageGenerator.swift <Package Name>`
2. Drag new module to GistHub.xcodepro

## Resolve all Modules

```bash
cd GistHub/
sh Scripts/resolve_packages.sh
```