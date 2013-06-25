/* 
 * To change this template, choose Tools | Templates
 * and open the template in the editor.
 */


var labelType, useGradients, nativeTextSupport, animate;

(function() {
    var ua = navigator.userAgent,
    iStuff = ua.match(/iPhone/i) || ua.match(/iPad/i),
    typeOfCanvas = typeof HTMLCanvasElement,
    nativeCanvasSupport = (typeOfCanvas == 'object' || typeOfCanvas == 'function'),
    textSupport = nativeCanvasSupport 
    && (typeof document.createElement('canvas').getContext('2d').fillText == 'function');
    //I'm setting this based on the fact that ExCanvas provides text support for IE
    //and that as of today iPhone/iPad current text support is lame
    labelType = (!nativeCanvasSupport || (textSupport && !iStuff))? 'Native' : 'HTML';
    nativeTextSupport = labelType == 'Native';
    useGradients = nativeCanvasSupport;
    animate = !(iStuff || !nativeCanvasSupport);
})();

var Log = {
    elem: false,
    write: function(text){
        if (!this.elem) 
            this.elem = document.getElementById('log');
        this.elem.innerHTML = text;
        this.elem.style.left = (500 - this.elem.offsetWidth / 2) + 'px';
    }
};

//"#FF9900","#336600",
  var heatMapJson = {
    
        "children":[
        ],
        "id": "", 
        "name": "",
        "data": {
                }
	 

    };
function initHeatMap(){
    //init data
  
    //end
    //init TreeMap
    var tm = new $jit.TM.Squarified({
        //where to inject the visualization
        injectInto: 'infovis-body',
        //parent box title heights
        titleHeight: 0,
        //enable animations
        animate: animate,
        //box offsets
        offset: 1,
        //Attach left and right click events
        Events: {
            enable: true,
            onClick: function(node) {
              
                 
                if(node) tm.enter(node);
               document.getElementById('heatMapInnerText'+node.id).style.display='block';
            },
            onRightClick: function(node) {
              
                  document.getElementById('heatMapInnerText'+node.id).style.display='none';
                tm.out();
            }
        },
        duration: 1000,
        //Enable tips
        Tips: {
            enable: false,
            //add positioning offsets
            offsetX: 20,
            offsetY: 20,
            //implement the onShow method to
            //add content to the tooltip when a node
            //is hovered
            onShow: function(tip, node, isLeaf, domElement) {
                var html = "<div class=\"tip-title\">" + node.id 
                + "</div><div class=\"tip-text\">";
                var data = node.data;
                if(data.details) {
                    html += data.details;
                }
                if(data.image) {
                    html += "<img src=\""+ data.image +"\" class=\"album\" />";
                }
                tip.innerHTML =  html; 
            }  
        },
        //Add the name of the node in the correponding label
        //This method is called once, on label creation.
        onCreateLabel: function(domElement, node){
            debugger;
            domElement.innerHTML = '<div id="heatMapInnerText'+node.id+'" style="display:none">'+node.name+'</div>';
            var style = domElement.style;
            style.display = '';
            style.border = '1px solid transparent';
            style.color='white';
            style.paddingTop='15%';
            style.paddingLeft='4%';
            domElement.onmouseover = function() {
                style.border = '1px solid #9FD4FF';
            };
            domElement.onmouseout = function() {
                style.border = '1px solid transparent';
            };
        }
    });
    tm.loadJSON(heatMapJson);
    tm.refresh();

}
