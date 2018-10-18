var list = document.getElementsByClassName('film-title');
var ret = ""
for(var i = 0;i<list.length;i++){
   ret +=  list[i].innerHTML;
}

ret