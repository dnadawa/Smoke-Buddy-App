import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:image_downloader/image_downloader.dart';
import 'package:smoke_buddy/widgets/toast.dart';

class ExtendedWallpaper extends StatefulWidget {

  final int index;
  final List wallpapers;
  const ExtendedWallpaper({Key key, this.index, this.wallpapers}) : super(key: key);

  @override
  _ExtendedWallpaperState createState() => _ExtendedWallpaperState();
}

class _ExtendedWallpaperState extends State<ExtendedWallpaper> {

  PageController controller;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    controller = PageController(initialPage: widget.index);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: widget.wallpapers!=null?PageView.builder(
        controller: controller,
        itemCount: widget.wallpapers.length,
        itemBuilder: (context,i){
          return Stack(
            children: [
              
              ///image
              Container(
                width: double.infinity,
                height: double.infinity,
                child: Hero(
                  tag: widget.index,
                  child: CachedNetworkImage(
                    imageUrl: widget.wallpapers[i]['url'],
                    fit: BoxFit.fill,
                    placeholder: (context,url)=>Image.asset('assets/images/loading.gif'),
                  ),
                ),
              ),
              
              
              
              ///download button
              Align(
                alignment: Alignment.bottomRight,
                child: Padding(
                  padding: EdgeInsets.all(ScreenUtil().setWidth(30)),
                  child: FloatingActionButton(
                    onPressed: () async {
                      try {
                        ToastBar(text: 'Downloading...',color: Colors.orange).show();
                        var imageId = await ImageDownloader.downloadImage(widget.wallpapers[i]['url']);
                        var path = await ImageDownloader.findPath(imageId);
                        ToastBar(text: 'Downloaded to $path',color: Colors.green).show();
                      } on PlatformException catch (error) {
                        ToastBar(text: 'Something went wrong',color: Colors.red).show();
                      }
                    },
                    child: Icon(Icons.download_rounded,color: Theme.of(context).primaryColor,),
                  ),
                ),
              )
            ],
          );
        },
      ):Center(child: CircularProgressIndicator(),),
    );
  }
}
