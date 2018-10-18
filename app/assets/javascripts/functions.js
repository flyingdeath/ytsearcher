


  function onYouTubeIframeAPIReady() {
    player = new YT.Player('ytplayer', {
      height: '480',
      width: '853',
      videoId: 'ZogKxtyUaY',
      events: {
        onReady: onPlayerReady
      }
    });
  }

  function playVideo(term){
    player.loadVideoById(getSelectedId(term));
  }

  function changeCueLink(term){
    player.cueVideoById(getSelectedId(term));
  }

  function onPlayerReady(event) {
    if(event){
      if(event.target.b.b.videoId !== 'ZogKxtyUaY'){
        event.target.playVideo();
      }
    }
  }


   function jsonIndexOf(list,v){
      var ret = -1;
      for(var l in list){
        if(list[l] == v){
          ret = l
          break;
        }
      }
      return ret;
   }



  function cursorMove(event){
    var temp = 0;
    var mousePosition = [event.pageX,event.pageY];

    $("#guideObject").offset({ top: mousePosition[1] - 14})

  }

  function checkScroll(event,obj1,obj2){
    var search_area = document.getElementById('search_area');
    var resultsPanel = document.getElementById('resultslist');
    if(event.target.id == "search_area"){
      resultsPanel.scrollTop = search_area.scrollTop;
    }else{
      search_area.scrollTop = resultsPanel.scrollTop;
    }
    search_area = null;
    resultsPanel = null;

  }


  function getSelectedId(term){
    var obj = document.getElementById('idList' + term)
    var id = obj.options[obj.selectedIndex].value;
    obj = null;
    return id;
  }

  function addCategories(){
    var cats = document.getElementById('cats');
    var selectCategories = document.getElementById('selectCategories');
    var label = selectCategories.options[selectCategories.selectedIndex].label;
    if(cats.value.indexOf(label) == -1){
      if(cats.value !== ""){
      cats.value += ", ";
      }
      cats.value += label;
    }
    selectCategories = null;
    cats = null;

  }

  function playAll(){
    var selectList = $(".videoSelectList");
    var playList = [];
    for(var i =0 ;i<selectList.length;i++){
      playList = playList.concat([selectList[i].value]);
    }
    selectList = null;
    player.loadPlaylist(playList);


  }