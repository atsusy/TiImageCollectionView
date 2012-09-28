var module = require('jp.msmc.imagecollectionview');
var flickrApiKey = '<YOUR API KEY HERE>';

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

var queryContext = {
	searching:false,
	page:0,
	countPerPage:48,
	images:[]
};

var searchFlickr = function(args)
{
	var url = 'http://www.flickr.com/services/rest/?format=json'
	url += '&api_key='+flickrApiKey;
	url += '&method=flickr.interestingness.getList'
	url += '&nojsoncallback=1';
	url += '&per_page='+args.countPerPage;
	url += '&page='+args.page;

	var client = Ti.Network.createHTTPClient({
		onload:function(e){
			var images = JSON.parse(this.responseText).photos.photo;
			
			/* append result */
			args.images = args.images.concat(images.map(function(image){
				var url = "http://farm"+image.farm+".staticflickr.com/";
				url += image.server+"/";
				url += image.id+"_";
				url += image.secret+"_q.jpg";
				return {
					id:image.id,
					url:url
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
	searchFlickr(queryContext);
});

imageCollectionView.addEventListener('selected', function(e){
	alert("id:"+ e.item.id + ' url:' + e.item.url);
});

imageCollectionView.addEventListener('scroll', function(e){
	if(queryContext.searching){
		return;
	}
	var heightToBottom = (e.contentSize.height - e.contentOffset.y);
	if(heightToBottom < Ti.Platform.displayCaps.platformHeight * 1.1){
		queryContext.page++;
		searchFlickr(queryContext);
	}
});

imageCollectionView.addEventListener('scrollEnd', function(e){
	Ti.API.info("scroll end offset x:" + e.contentOffset.x + " y:" + e.contentOffset.y);
});

window.add(imageCollectionView);
window.open();

