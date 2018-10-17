
    window.onerror = function(msg, url, line, col, error) {
        var errmsg = "file:" + url + "<br>line:" + line + " " + msg;
        Simple.myerror(errmsg);
    }

    var Simple = function() {
        $("#canvas").css("display", "block")

        this.live2DModel = null;
        this.requestID = null;
        this.loadLive2DCompleted = false;
        this.initLive2DCompleted = false;
        this.loadedImages = [];
        var  motion  =  null ;      // 모션
        var  motionMgr  =  null ;   // 모션 매니저
        var unitId = document.getElementById('unit_id').getAttribute("value");
        console.log(unitId);
        this.modelDef = {
            "type":"Live2D Model Setting",
            "name":"c386_01",
            "model":'/live2d_models/' + unitId + '/character.dat',
            "textures":[
              '/live2d_models/' + unitId + '/texture_00.png',

            ],
            "motion":'/live2d_models/' + unitId + '/' + unitId + '_idle.mtn'
        };

        Live2D.init();

        var canvas = document.getElementById("glcanvas");

        canvas.addEventListener("webglcontextlost", function(e) {
            Simple.myerror("context lost");
            loadLive2DCompleted = false;
            initLive2DCompleted = false;

            var cancelAnimationFrame =
                window.cancelAnimationFrame ||
                window.mozCancelAnimationFrame;
            cancelAnimationFrame(requestID);
            e.preventDefault();
        }, false);

        canvas.addEventListener("webglcontextrestored" , function(e){
            Simple.myerror("webglcontext restored");
            Simple.initLoop(canvas);
        }, false);

        Simple.initLoop(canvas);
    };


    Simple.initLoop = function(canvas)
    {
        var para = {
            premultipliedAlpha : true,
        };
        var gl = Simple.getWebGLContext(canvas, para);
        if (!gl) {
            Simple.myerror("Failed to create WebGL context.");
            return;
        }

        Live2D.setGL(gl);

        Simple.loadBytes(modelDef.model, function(buf){
            live2DModel = Live2DModelWebGL.loadModel(buf);
        });

        var loadCount = 0;
        for(var i = 0; i < modelDef.textures.length; i++){
            (function ( tno ){
                loadedImages[tno] = new Image();
                loadedImages[tno].src = modelDef.textures[tno];
                loadedImages[tno].onload = function(){
                    if((++loadCount) == modelDef.textures.length) {
                        loadLive2DCompleted = true;
                    }
                }
                loadedImages[tno].onerror = function() {
                    Simple.myerror("Failed to load image : " + modelDef.textures[tno]);
                }
            })( i );
        }

      // 모션로드
        Simple . loadBytes ( modelDef . motion ,  function ( buf ) {
            motion  =  new  Live2DMotion . loadMotion ( buf );
        });
        motionMgr  =  new  L2DMotionManager ();

        (function tick() {
            Simple.draw(gl);

            var requestAnimationFrame =
                window.requestAnimationFrame ||
                window.mozRequestAnimationFrame ||
                window.webkitRequestAnimationFrame ||
                window.msRequestAnimationFrame;
                requestID = requestAnimationFrame( tick , canvas );
        })();
    };

    Simple.draw = function(gl)
    {
        gl.clearColor( 0.0 , 0.0 , 0.0 , 0.0 );
        gl.clear(gl.COLOR_BUFFER_BIT);

        if( ! live2DModel || ! loadLive2DCompleted )
            return;

        if( ! initLive2DCompleted ){
            initLive2DCompleted = true;

            for( var i = 0; i < loadedImages.length; i++ ){
                var texName = Simple.createTexture(gl, loadedImages[i]);

                live2DModel.setTexture(i, texName);
            }

            loadedImages = null;

            var s = .9 / live2DModel.getCanvasWidth();
            // ORIGINAL // var matrix4x4 = [
            //     s*2, 0, 0, 0,
            //     0, -s, 0, 0,
            //     0, 0, 1, 0,
            //    -1, 1, 0, 1
            // ];
            var matrix4x4 = [
                s*1.5, 0, 0, 0,
                0, -s*1.5, 0, 0,
                0, 0, 0, 0,
               -0.7, 1.3, 0, 1
            ];
            live2DModel.setMatrix(matrix4x4);
        }

        live2DModel.update();
        live2DModel.draw();
        if ( motionMgr . isFinished ()) {
            motionMgr . startMotion ( motion );
        }
        motionMgr . updateParam ( live2DModel );
    };

    Simple.getWebGLContext = function(canvas/*HTML5 canvasオブジェクト*/)
    {
        var NAMES = [ "webgl" , "experimental-webgl" , "webkit-3d" , "moz-webgl"];

        var param = {
            alpha : true,
            premultipliedAlpha : true
        };

        for( var i = 0; i < NAMES.length; i++ ){
            try{
                var ctx = canvas.getContext( NAMES[i], param );
                if( ctx ) return ctx;
            }
            catch(e){}
        }
        return null;
    };

    Simple.createTexture = function(gl/*WebGLコンテキスト*/, image/*WebGL Image*/)
    {
        var texture = gl.createTexture(); //テクスチャオブジェクトを作成する
        if ( !texture ){
            mylog("Failed to generate gl texture name.");
            return -1;
        }

        if(live2DModel.isPremultipliedAlpha() == false){
            // 乗算済アルファテクスチャ以外の場合
            gl.pixelStorei(gl.UNPACK_PREMULTIPLY_ALPHA_WEBGL, 1);
        }
        gl.pixelStorei(gl.UNPACK_FLIP_Y_WEBGL, 1);	//imageを上下反転
        gl.activeTexture( gl.TEXTURE0 );
        gl.bindTexture( gl.TEXTURE_2D , texture );
        gl.texImage2D( gl.TEXTURE_2D , 0 , gl.RGBA , gl.RGBA , gl.UNSIGNED_BYTE , image);
        gl.texParameteri(gl.TEXTURE_2D, gl.TEXTURE_MAG_FILTER, gl.LINEAR);
        gl.texParameteri(gl.TEXTURE_2D, gl.TEXTURE_MIN_FILTER, gl.LINEAR_MIPMAP_NEAREST);
        gl.generateMipmap(gl.TEXTURE_2D);
        gl.bindTexture( gl.TEXTURE_2D , null );

        return texture;
    };

    Simple.loadBytes = function(path , callback)
    {
        var request = new XMLHttpRequest();
        request.open("GET", path , true);
        request.responseType = "arraybuffer";
        request.onload = function(){
            switch( request.status ){
            case 200:
                callback( request.response );
                break;
            default:
                Simple.myerror( "Failed to load (" + request.status + ") : " + path );
                break;
            }
        }

        request.send(null);
    };

    Simple.mylog = function(msg/*string*/)
    {
        var myconsole = document.getElementById("myconsole");
        myconsole.innerHTML = myconsole.innerHTML + "<br>" + msg;
        console.log(msg);
    };

    Simple.myerror = function(msg/*string*/)
    {
        console.error(msg);
        Simple.mylog( "<span style='color:red'>" + msg + "</span>");
    };
