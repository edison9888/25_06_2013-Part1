/* 
 * 
 * Vishnu C
 */


Ext.define('AFE.controller.ContentHeaderViewController', {
    extend: 'Ext.app.Controller',
    views: [
    'ContentHeaderView'
    ],
    init: function() {
        this.control(
        {
            'contentHeaderView label[id=showFullScreen]': {
                click:this.onFullScreenClick
            }
        }
        );
    },
    onFullScreenClick:function(){
        var docElm = document.documentElement;
        if (docElm.requestFullscreen) {
            docElm.requestFullscreen();
        }
        else if (docElm.mozRequestFullScreen) {
            docElm.mozRequestFullScreen();
        }
        else if (docElm.webkitRequestFullScreen) {
            docElm.webkitRequestFullScreen();
        }
    }
});