
  var player;

  window.onload = function() {

    /*--------------------------------------------------------------------------------------------------------------------*/
    var tag = document.createElement('script');
    tag.src = "https://www.youtube.com/player_api";

    var firstScriptTag = document.getElementsByTagName('script')[0];
    firstScriptTag.parentNode.insertBefore(tag, firstScriptTag);
    tag = null;
    firstScriptTag = null;

    /*--------------------------------------------------------------------------------------------------------------------*/

    $('#guideObject').bind('mousemove', cursorMove);
    $('#guideContainer').bind('mousemove', cursorMove);
    $('#search_area').bind('mousemove', checkScroll);
    $('#search_area').bind('mouseup', checkScroll);
    $('#search_area').bind('mousewheel', checkScroll);
    $('#search_area').bind('DOMMouseScroll', checkScroll);
    $('#resultslist').bind('mousemove', checkScroll);
    $('#resultslist').bind('mouseup', checkScroll);

    /*--------------------------------------------------------------------------------------------------------------------*/
      $('#CueAll').click( function() {
         var selectList = $(".videoSelectList");
         var title = document.getElementById('title');
         var params = {};
         for(var i =0 ;i<selectList.length;i++){
           params[selectList[i].id.replace('idList','')] = selectList[i].options[selectList[i].selectedIndex].value;
         }
           console.log( title.value);
			$.ajax({
				type: "POST",
				url: "/mainpage/loadAllWatchLater",
				// The key needs to match your method's input parameter (case-sensitive).
				data: JSON.stringify({list: params, title: title.value}),
				contentType: "application/json; charset=utf-8",
				dataType: "json",
				success: function(data){
					 var selectList = $(".videoSelectList");
					 var j = data.errored_ids;
					 for(var i =0 ;i<selectList.length;i++){
					   if(jsonIndexOf(j, selectList[i].value) !== -1){
						  selectList[i].style.border = "red solid 1px";
					   }
					 }
					 selectList = null;
					 title = null;
				 },
				failure: function(errMsg) {
					alert(errMsg);
				}
			});
         selectList = null;
         title = null;
		});

      $('.cueBtn').click( function() {
		var title = document.getElementById('title');
		var id = getSelectedId(this.id.replace("cuebtn",""));


		$.ajax({
		type: "POST",
		url: "/mainpage/loadWatchLater/"+ id,
		// The key needs to match your method's input parameter (case-sensitive).
		data: JSON.stringify({ title: title.value}),
		contentType: "application/json; charset=utf-8",
		dataType: "json",
		success:  function(evt, data, status, xhr) {
					 var selectList = $(".videoSelectList");
					 var j = data.errored_ids;
					 for(var i =0 ;i<selectList.length;i++){
					   if(jsonIndexOf(j, selectList[i].value) !== -1){
						  selectList[i].style.border = "red solid 1px";
					   }
					 }
					 selectList = null;
					 title = null;
		 },
		failure: function(errMsg) {
			alert(errMsg);
		}
		});
        title = null;

	});
		/*

      $('#CueAll').bind('ajax:before', function() {
         var selectList = $(".videoSelectList");
         var title = document.getElementById('title');
         var params = {};
         for(var i =0 ;i<selectList.length;i++){
           params[selectList[i].id.replace('idList','')] = selectList[i].options[selectList[i].selectedIndex].value;
         }
         selectList = null;
           console.log( title.value);
         $(this).data('params', {list: params, title: title.value});
         title = null;
      });


      $('#CueAll').bind('ajax:success', function(evt, data, status, xhr) {
         var selectList = $(".videoSelectList");
         var j = data.errored_ids;
         for(var i =0 ;i<selectList.length;i++){
           if(jsonIndexOf(j, selectList[i].value) !== -1){
              selectList[i].style.border = "red solid 1px";
           }
         }
         selectList = null;
         title = null;
      });*/
      /*--------------------------------------------------------------------------------------------------------------------*/

/*

      $('.cueBtn').bind('ajax:success', function(evt, data, status, xhr) {
         var selectList = $(".videoSelectList");
         var j = data.errored_ids;
         for(var i =0 ;i<selectList.length;i++){
           if(jsonIndexOf(j, selectList[i].value) !== -1){
              selectList[i].style.border = "red solid 1px";
           }
         }
         selectList = null;
         title = null;
      });

      $('.cueBtn').bind('ajax:before',  function() {
        var title = document.getElementById('title');
         $(this).data('params', {title:  title.value});
         title = null;
      });
*/
    /*--------------------------------------------------------------------------------------------------------------------*/
      $( document ).tooltip({items: "[dataMeta]",
           position: {
              my: "left-340 bottom+30",
              at: "left left",
              using: function( position, feedback ) {
              $( this ).css( position );
              $( "<div>" )
              .addClass( "arrow" )
              .addClass( feedback.vertical )
              .addClass( feedback.horizontal )
              .appendTo( this );
              }
        },
        content: function() {
          var data  = metaData();
          var element = $( this );
          if ( element.is( "[dataMeta]" ) ) {
            var unique_id = "";
            if(element[0].nodeName == "OPTION"){
              unique_id = element[0].getAttribute('value');
            }else{
              unique_id = element[0].options[element[0].selectedIndex].value;
            }
            return data[unique_id];
          }
        }
    });

    /*--------------------------------------------------------------------------------------------------------------------*/
  }

