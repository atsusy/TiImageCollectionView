var module = require('jp.msmc.imagecollectionview');

var window = Ti.UI.createWindow({
});

var activityIndicator = Ti.UI.createActivityIndicator({
	style:Ti.UI.iPhone.ActivityIndicatorStyle.DARK,
	font: {
		fontFamily:'Helvetica Neue', 
		fontSize:20, 
		fontWeight:'bold'
	},
  	message: 'Loading...',	
  	backgroundColor:'white',
  	color:'#444',
	height:32
});

var imageCollectionView = module.createImageCollectionView({
	left:0,
	top:0,
	placeHolder:'placeHolder.png',
	selectionGlowColor:'red',
	selectionGlowRadius:4.0,
	cellSize:{ 
		width:79.0, 
		height:79.0 
	},
	cellPadding:{ 
		x:2, 
		y:2 
	},
	backgroundColor:'white',
	leftContentInset:2,
	rightContentInset:2,
	footerView:activityIndicator
});

var copyrightForBjinMe = Ti.UI.createLabel({
	backgroundColor:'black',
	color:'white',
	font:{
		fontFamily:'Helvetica Neue' ,
		fontSize:12,
		fontWeight:'bold'
	},
	textAlign:'right',
	width:Ti.UI.FILL,
	height:24,
	bottom:0,
	opacity:0.8,
	text:'Bjin.Me API '
});

var bjinmeQueryContext = {
	searching:false,
	page:0,
	countPerPage:48,
	images:[]
};

var searchBjinMe = function(args)
{
	var url = 'http://bjin.me/api/?type=rand&format=json'
	url += '&count='+args.countPerPage;

	var client = Ti.Network.createHTTPClient({
		onload:function(e){
			var images = JSON.parse(this.responseText);
			
			/* append result */
			args.images = args.images.concat(images.map(function(image){
				return {
					id:image.id,
					url:image.thumb
				}
			}));

			/* redisplay images */
			imageCollectionView.images = args.images;

			/* has next page? */
			if(images.length === args.countPerPage){
				imageCollectionView.footerView.show();
			}else{
				imageCollectionView.footerView.hide();
			}
			args.searching = false;
		},
		onerror:function(e){
			alert(e.error);

			imageCollectionView.footerView.hide();
			args.searching = false;
		}
	});
	client.open('GET', url);
	client.send();

	args.searching = true;
}

window.addEventListener('open', function(){
	searchBjinMe(bjinmeQueryContext);
});

imageCollectionView.addEventListener('selected', function(e){
	alert("id:"+ e.item.id + ' url:' + e.item.url);
});

imageCollectionView.addEventListener('scroll', function(e){
	if(bjinmeQueryContext.searching){
		return;
	}
	var heightToBottom = (e.contentSize.height - e.contentOffset.y);
	if(heightToBottom < Ti.Platform.displayCaps.platformHeight * 1.1){
		bjinmeQueryContext.page++;
		searchBjinMe(bjinmeQueryContext);
	}
});

imageCollectionView.addEventListener('scrollEnd', function(e){
	Ti.API.info("scroll end offset x:" + e.contentOffset.x + " y:" + e.contentOffset.y);
});

copyrightForBjinMe.addEventListener('click', function(e){
	Ti.Platform.openURL('http://bjin.me');
});

window.add(imageCollectionView);
window.add(copyrightForBjinMe);
window.open();

