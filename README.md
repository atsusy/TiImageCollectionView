TiImageCollectionView module
===========================================
Titanium Mobile Module project for listing web images.

INSTALL MODULE
--------------------
1. Run `build.py` which creates your distribution
2. cd to `/Library/Application Support/Titanium`
3. copy this zip file into the folder of your Titanium SDK

REGISTER MODULE
---------------------
Register your module with your application by editing `tiapp.xml` and adding your module.
Example:

	<modules>
		<module version="0.6">jp.msmc.imagecollectionview</module>
	</modules>

When you run your project, the compiler will know automatically compile in your module
dependencies and copy appropriate image assets into the application.

USING MODULE IN CODE
-------------------------
To use your module in code, you will need to require it. 
Then create ImageCollectionView object by calling `createIimageCollectionView` method.

For example,

	var module = require('jp.msmc.imagecollectionview');
	var imageCollectionView = module.createImageCollectionView({
		left:0,
		top:0,
		…
	});

PROPERTIES
-------------------------
###ImageCollectionView
Name  					| Type		  | Description
:-------------------|:--------- | :-----------------------------------------------------------
images  				| (array)   | list of images for displaying. each object must have property `url`.
placeHolder  			| (string)  | place holder image
cellSize				| (object)  | width(integer) - width of a cell 
						|			  | height(integer) - height of a cell
cellPadding			| (object)  | x(integer) - padding size of left for a cell
						|			  | y(integer) - padding size of top for a cell
leftContentInset		| (integer) | inset size of left for a grid
rightContentInset	| (integer) | inset size of top for a grid
selectionGlowColor	| (string)  | color of selected effect
selectionGlowRadius	| (integer) | radius of selected effect 
headerView			| (view)	  | a view for header
footerView			| (view)    | a view for footer

EVENTS
-------------------------
###ImageCollectionView
Name  		| Description           | Properties
:---------|:--------------------- |:---------------------------------------------------------
selected  | image is selected.    | `item` a selected image. (an element of `images`)
scroll		| grid is scrolled.     | `contentOffset` dictionary with x and y properties containing the content offset. `contentSize` dictionary with width and height properties containing the size of the content.
scrollEnd	| grid stops scrolling. |`contentOffset` dictionary with x and y properties containing the content offset. `contentSize` dictionary with width and height properties containing the size of the content.

ABOUT EXAMPLE APP
-------------------------
Example app is in `example` directory. This app lists Flickr interesting photos.
Flickr API key is required. Modify app.js with your Flickr API key. See [http://www.flickr.com/services/api/](http://www.flickr.com/services/api/).

LICENSE
-------------------------
MIT License
