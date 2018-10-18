 

var list = document.getElementsByClassName('normal');
var ret = ""
for(var i = 0;i<list.length;i++){
   ret +=  list[i].childNodes[0].innerHTML;
}

ret
