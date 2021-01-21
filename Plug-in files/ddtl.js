function BuildTreeLinks( pTreeId
                       , pTreeStaticId
				       , pDisplayBlockId
					   , pHiddenElementId
				  
				       , pPageItemToReturn
				  
				       , pEngine
					   , pTheme
				  
				       , pRemoveIcons
				       , pAutoExpand
				       , pAutoSize ) {
    
	// APEX 5.0 TREE
	if ( pEngine == 'APEX_TREE' ) {
	
		var lTreeArr = apex.jQuery("#" + pTreeStaticId + " li");
		var lObj = window[ "g" + pTreeId.substr(0,1).toUpperCase() + pTreeId.substr(1) + "Data" ];
		
		TreeObjLoop( lObj, function(pObj,pIndex){
			
			var lNodeId = pObj.id;
			var lNodeText = pObj.label;

			lTreeArr.eq(pIndex).find("a:first").attr("href","#");
			pObj.link = 'JavaScript: SelectTreeNode2("'+pTreeStaticId+'","'+pPageItemToReturn+'","'+pDisplayBlockId+'","'+pHiddenElementId+'","'+lNodeId+'","'+lNodeText+'" );';
		});
	// JSTREE / PLUGIN
	} else {
		apex.jQuery("#" + pTreeStaticId + " li").each( function() {

			var lNodeId = apex.jQuery(this).attr("id");
			var lNodeText;

			// remove extra whitespace
			lNodeText = apex.jQuery.trim( apex.jQuery(this).children("a").text() );

			// set link
			apex.jQuery(this).children("a").attr("href",'JavaScript: SelectTreeNode("'+pTreeStaticId+'","'+pPageItemToReturn+'","'+pDisplayBlockId+'","'+pHiddenElementId+'","'+lNodeId+'","'+lNodeText+'" );');
		});
	}
}

function TreeObjLoop ( pObj, callback ) {
	
	if ( !window.gDDTL_StartIndex ) window.gDDTL_StartIndex = 0;
	
	if ( typeof(pObj)=="object" ) { 
	
		callback.call(null,pObj,gDDTL_StartIndex);
		
		if (pObj.children)
			for (var i=0;i<pObj.children.length;i++) {
			
				gDDTL_StartIndex++;
				TreeObjLoop( pObj.children[i], callback );
			}
			
	} else if ( typeof(pObj)=="array" ) {

		for (var i=0;i<pObj.length;i++) {
			
			gDDTL_StartIndex++;
			TreeObjLoop( pObj[i], callback );
		}
	}
}

function SelectTreeNode2( pTreeStaticId, pPageItemToReturn, pDisplayBlockId, pHiddenElementId, pNodeId, pNodeText ) {

	apex.jQuery("#" + pDisplayBlockId + " .ddtl_text").text(pNodeText); 
	apex.jQuery("#" + pTreeStaticId ).hide();
	$s(pHiddenElementId,pNodeText);
	
	// set page item to return id
	if ( pPageItemToReturn )  $s(pPageItemToReturn, pNodeId);
}

function SelectTreeNode( pTreeStaticId, pPageItemToReturn, pDisplayBlockId, pHiddenElementId, pNodeId, pNodeText ) {


	apex.jQuery("#" + pTreeStaticId + " .clicked").removeClass("clicked"); 
	apex.jQuery("#" + pTreeStaticId + " #" + pNodeId ).children("a").addClass("clicked"); 
	apex.jQuery("#" + pDisplayBlockId + " .ddtl_text").text(pNodeText); 
	apex.jQuery("#" + pTreeStaticId ).hide(); 
	$s(pHiddenElementId,pNodeText);
	
	// set page item to return id
	if ( pPageItemToReturn )  $s(pPageItemToReturn, pNodeId);
}

function FixOverflowHidden(pTreeStaticId) {

	apex.jQuery("#" + pTreeStaticId).parents().css("overflow","visible");
}

function ddtl_init( pTreeId
                  , pTreeStaticId
				  , pDisplayBlockId
				  , pHiddenElementId
				  
				  , pPageItemToReturn
				  
				  , pEngine
				  , pTheme
				  
				  , pRemoveIcons
				  , pAutoExpand
				  , pAutoSize ) {
	
	
	// expand nodes
	if ( pRemoveIcons == 'y' || pAutoExpand == 'all' ) {

		if ( pTreeId )  apex.widget.tree.expand_all(pTreeId);
	}
		
	// remove icons
	if ( pRemoveIcons == 'y' ) {

		if ( pTreeId && pEngine != 'APEX_TREE' ) {
				
			if ( apex.jQuery.fn.off ) {

				apex.jQuery("#" + pTreeId ).unbind().off(); 
			} else {

				apex.jQuery("#" + pTreeId ).unbind().die(); 
			}
		}
		
		if ( pEngine == 'APEX_TREE' ) {
		
			apex.jQuery("#" + pTreeId + " .a-TreeView-toggle" ).remove();
		} else {
			apex.jQuery("#" + pTreeStaticId).addClass("ddtl_static_" + pTheme );
		}
    }
	
	// show drop down tree list
	apex.jQuery("#" + pDisplayBlockId).click(function(event) { 

		apex.jQuery("#" + pTreeStaticId).show(); 

		if ( pAutoSize == 1 ) {

			if (apex.jQuery("#" + pTreeStaticId + " li:first").length > 0) 
				
				apex.jQuery("#" + pTreeStaticId).css("width", parseInt(apex.jQuery("#" + pTreeStaticId + " li:first").css("width"))+45+"px"); 
			else
				apex.jQuery("#" + pTreeStaticId).css("width", "100px"); 
		}

		apex.jQuery("#" + pTreeStaticId).position({my:"left top", at:"bottom", of:"#" + pDisplayBlockId + " .ddtl_image_" + pTheme, collision:"fit"});
		event.stopPropagation();
	});

	// hide tree region on click outside
	apex.jQuery(document).click(function() {

		apex.jQuery("#" + pTreeStaticId).hide();
	});

	// The area inside of the tree region and outside of the links shouldn't be clickable
	apex.jQuery("#" + pTreeStaticId).click( function(event) {

		event.stopPropagation();
	});


	// Override default handler for tree links
	BuildTreeLinks(pTreeId
                 , pTreeStaticId
				 , pDisplayBlockId
				 , pHiddenElementId
				  
				 , pPageItemToReturn
				  
				 , pEngine
				 , pTheme
				  
				 , pRemoveIcons
				 , pAutoExpand
				 , pAutoSize);

	// Surpass overflow:hidden universal theme region layout
	FixOverflowHidden(pTreeStaticId);

	// build links
	apex.jQuery("#" + pTreeStaticId).bind("apexafterrefresh", function() { 
	
		BuildTreeLinks(pTreeId
					 , pTreeStaticId
					 , pDisplayBlockId
					 , pHiddenElementId
				  
					 , pPageItemToReturn
				  
					 , pEngine
					 , pTheme
				  
					 , pRemoveIcons
					 , pAutoExpand
					 , pAutoSize); 
	});
	
	// Bug Fix for Apex 5.0.0 - 5.0.1 (TypeError: a.curCSS is not a function)
	// Apex 5.0 is shipped with jQuery 2.1.3 that is not fully compatible with the old jsTree apex implementation
	if ( !apex.jQuery.curCSS && pEngine == 'JSTREE' )  apex.jQuery.curCSS = function (element,attrib,val) { apex.jQuery(element).css(attrib,val); }
}