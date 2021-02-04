 Drop Down Tree List Plug-in
 ===================
 Release 2.0

 Home page: https://github.com/ivyachmenev/Drop-Down-Tree-List
 Demo: https://apex.oracle.com/pls/apex/f?p=73108:2::::::

 This Plugin is free and licensed under the MIT license ( http://www.opensource.org/licenses/mit-license.php )

 INSTRUCTION
 ===================
 First create a tree region, fill Static ID attribute. Then create Drop Down Tree List item plug-in, enter the same Tree Region Static ID.
 That's all. You can customize appearance by using different themes, templates, region attributes.

 See documentation for more information.


 CHANGE LOG
 ===================

 Changes in 2.0.2:

 * Fixed item selection (apex 20.2)

 -------------------

 Changes in 2.0.1:

 * Fixed a regression of: plug-in is not clickable in Universal Theme

 -------------------

 Changes in 2.0:

 * Stable release.

 * Static resources (css, js) are now minified similar way as apex resources are.
   i.e. you have access to full resource version when using apex debug mode 
   and to minified resource version when using normal mode.

 -------------------

 Changes in 2.0 beta:

 * Basic APEX 5.0 support, including:
 
   jsTree Implementation Support
   APEX 5.0 Tree Implementation Support
   Universal Theme Support
 
 * Fixed: Extra whitespace when selecting tree nodes.

 * New component attributes: Readonly attributes.

 * Changes are made to "Page Item to Return Node Value" attribute: "None" is now excluded from options. 
   It means that "Derived From 'Selected Node Page Item' Attribute of Tree Region" is the only option available and is for information purposes only.
   Filling "Selected Node Page Item" is recommended for animation to work properly.

 * All jquery references were replaced to apex.jQuery

 * Plug-in is now compatible with jQuery v2.1.3

 * Static resources are now contained in separate png/js/css files.

 * license.txt file was added.

 -------------------

 Changes in 1.0:

 * Stable release.
 
   The Plug-In is developed for Apex 4.2 
   Apex 5.0 is not supported yet.

 -------------------

 Changes in 1.0 beta:

 * Fixed: The area inside of tree region and outside of tree links is not clickable anymore.


 * New global component attribute: Width Auto-Sizing was added.
   In the privious releases it was always enabled, however in this release it's disabled by default.

 * New component attribute: Hide Expand/Collapse Icons was added. 
   Default: Yes (Same behavior as in privious release).

 * New component attribute: Expand Automatically was added.
   Default: Yes (Same behavior as in privious release).

   See documentation and help for more information about new attributes.


 * Documentation now includes global component settings chapter and an example of using dynamic actions.

 * Starting with this release gpl license was excluded from CREDITS AND LICENSE as I don't think it's suited for using with apex.

 -------------------

 Changes in 0.9.2 beta:

 * Fixed: wrong icon was displayed in the case when using several plug-in items with different tree templates on one page.

 * documentation was added.

 -------------------

 Changes in 0.9.1 beta:

 * Fixed: issue with hanging on apex hostings (apex.oracle.com).

 * readme file was added.

 -------------------

 Changes in 0.9 beta:

 * first release
