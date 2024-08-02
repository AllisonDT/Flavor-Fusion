# Setting Up Xcode and Repository for Development

This guide will walk you through the process of installing and setting up Xcode, followed by creating a repository for development.

## Installing Xcode

1. **Check System Requirements**: Before installing Xcode, make sure your Mac meets the system requirements. You can find the latest requirements on the [official Apple website](https://developer.apple.com/xcode/).

2. **Install Xcode from the Mac App Store**:
   - Open the Mac App Store on your Mac.
   - Search for Xcode in the search bar.
   - Click on the "Get" button next to Xcode to start the installation process.
   - Follow the on-screen instructions to complete the installation.

3. **Command Line Tools**: After installing Xcode, you may need to install the Command Line Tools. Open Terminal and run the following command:

```bash
xcode-select --install
```

4. **Agree to License Terms**: Launch Xcode, and agree to the license terms and conditions.

5. **Final Steps**: Xcode may require additional setup steps, such as signing in with your Apple ID or configuring preferences. Follow the prompts to complete the setup process.

## Setting Up Flavor Fusion for Development

1. **Clone the Repository**:
- Open Terminal.
- Navigate to the directory where you want to store the project.
- Use the following command to clone the repository:

```bash
git clone https://github.com/AllisonDT/Flavor-Fusion.git
```

2. **Start Developing**:
- Navigate into the cloned repository directory.
- Start developing your project using Xcode.

## Additional Resources

- [Xcode Documentation](https://developer.apple.com/documentation/xcode)
- [GitHub Guides](https://guides.github.com/)

## Summer Flavor Fusion Development
**July 2024**
- 7/1 implemented plus button for add recipe, implemented recipe search functionalit, drafted MixRecipePreview view
- 7/9 fixed bug where new vs existing view picker was moving up and down the screen, added selection button and amount selector for the new spice view selections
- 7/13 added floating blend button to NewBlendView view, drafted all of the blending pages for new blend
- 7/14 added blending from recipe book
- 7/15 updated BlendConfirmationView to include the ingredients that are in the blend, updated the BlendExistingView to have the confirmation, loading, and complete views, redesigned main list, added setting for changing display name
- 7/16 added list of recipes in SpicePopupView
- 7/20 fixed bug where user could only click on name not entire box on home list, redesigned style of SpicePopupView, styled NewBlendView to match home list, created ExistingRecipesRows file, added alerts
- 7/22 fixed functionality of MixRecipePreview
- 7/24 changed search bar style, added alert for blending, added images for team members to about view
- 7/31 fixed styling on the boxes for adding recipe and blend new recipe
- 8/1 changed colors for dark mode for more accessibility
       




