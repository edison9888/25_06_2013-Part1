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


function init(){
    //init data
    var json = {
    
        "children":[
       
        {
          
            "data": {
                "playcount": "120", 
                "$color": "#034508", 
                "image": "", 
                "$area": 120
            }, 
            "id": "album-Thirteenth Step", 
            "name": "Thirteenth Step"
        },
     
     
   
        {
         
            "data": {
                "playcount": "150", 
                "$color": "#77171D", 
                "image": "", 
                "$area": 150
            }, 
            "id": "album-Above-150", 
            "name": "Above"
        },
        {
           
            "data": {
                "playcount": "245", 
                "$color": "#AA5532", 
                "image": "", 
                "$area": 245
            }, 
            "id": "album-245", 
            "name": "Above"
        },
        {
           
            "data": {
                "playcount": "250", 
                "$color": "#920A86", 
                "image": "", 
                "$area": 250
            }, 
            "id": "album-250", 
            "name": "Above"
        }
        ,
        {
           
            "data": {
                "playcount": "609", 
                "$color": "#0900B0", 
                "image": "", 
                "$area": 609
            }, 
            "id": "album-609", 
            "name": "Above"
        }	
      ,
        {
           
            "data": {
                "playcount": "40", 
                "$color": "#F4B916", 
                "image": "", 
                "$area": 40
            }, 
            "id": "album-40", 
            "name": "Above"
        },
        {
           
            "data": {
                "playcount": "100", 
                "$color": "#2E0398", 
                "image": "", 
                "$area": 100
            }, 
            "id": "album-100", 
            "name": "Above"
        }
      
        ],
        "id": "", 
        "name": "",
        "data": {
    }
	 

    };
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
            enable: false,
            onClick: function(node) {
                if(node) tm.enter(node);
            },
            onRightClick: function() {
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
                var html = "<div class=\"tip-title\">" + node.name 
                + "</div><div class=\"tip-text\">";
                var data = node.data;
                if(data.playcount) {
                    html += "play count: " + data.playcount;
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
            domElement.innerHTML = node.name;
            var style = domElement.style;
            style.display = '';
            style.border = '1px solid transparent';
            domElement.onmouseover = function() {
                style.border = '1px solid #9FD4FF';
            };
            domElement.onmouseout = function() {
                style.border = '1px solid transparent';
            };
        }
    });
    tm.loadJSON(json);
    tm.refresh();

}
