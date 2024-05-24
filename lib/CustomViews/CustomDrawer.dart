import 'package:flutter/material.dart';
import 'dart:math';
import 'dart:io';
import 'package:image_picker/image_picker.dart';

class CustomDrawerAnimation extends StatefulWidget {
  final Widget drawer;
  final Widget child;
  final Function() onDrawerOpened;
  final Function() onDrawerClosed;

  const CustomDrawerAnimation({
    required this.drawer,
    required this.child,
    required this.onDrawerOpened,
    required this.onDrawerClosed,
  });

  @override
  _CustomDrawerAnimationState createState() => _CustomDrawerAnimationState();
}

class _CustomDrawerAnimationState extends State<CustomDrawerAnimation>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  final double maxSlide = 225;
  bool _isDrawerOpen = false;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 300),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void toggleDrawer() {
    if (_isDrawerOpen) {
      _controller.reverse();
      widget.onDrawerClosed();
    } else {
      _controller.forward();
      widget.onDrawerOpened();
    }
    _isDrawerOpen = !_isDrawerOpen;
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        GestureDetector(
          onTap: () {
            if (_isDrawerOpen) {
              toggleDrawer();
            }
          },
          child: widget.child,
        ),
        AnimatedBuilder(
          animation: _controller,
          builder: (context, _) {
            double angle = _controller.value * pi / 2;
            double xTranslation = MediaQuery.of(context).size.width * 0.6 * _controller.value;
            return Transform(
              transform: Matrix4.identity()
                ..setEntry(3, 2, 0.001) // Perspective
                ..rotateY(angle)
                ..translate(xTranslation),
              alignment: Alignment.centerLeft,
              child: ClipRect(
                child: Align(
                  alignment: Alignment.centerLeft,
                  widthFactor: 0.6,
                  child: widget.drawer,
                ),
              ),
            );
          },
        ),
      ],
    );
  }
}

class CustomDrawer extends StatefulWidget {
  final Function(int indice) onItemTap;
  final String imagen;

  CustomDrawer({Key? key, required this.onItemTap, required this.imagen})
      : super(key: key);

  @override
  _CustomDrawerState createState() => _CustomDrawerState();
}

class _CustomDrawerState extends State<CustomDrawer> {
  late String _currentImage;
  bool _isLocalImage = false;

  @override
  void initState() {
    super.initState();
    _currentImage = widget.imagen;
    _isLocalImage = Uri.parse(_currentImage).isScheme('file');
  }

  Future<void> _pickImage(ImageSource source) async {
    final ImagePicker _picker = ImagePicker();
    final XFile? image = await _picker.pickImage(source: source);

    if (image != null) {
      setState(() {
        _currentImage = image.path;
        _isLocalImage = true;
      });
    }
  }

  void _showImageWithZoom(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          backgroundColor: Colors.black54,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Expanded(
                child: InteractiveViewer(
                  panEnabled: false,
                  scaleEnabled: true,
                  child: _isLocalImage
                      ? Image.file(File(_currentImage))
                      : Image.network(_currentImage),
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  TextButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                      _pickImage(ImageSource.gallery);
                    },
                    child: Text(
                      'Cambiar por Galería',
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                  TextButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                      _pickImage(ImageSource.camera);
                    },
                    child: Text(
                      'Cambiar por Cámara',
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Container(
        color: Colors.white,
        child: ListView(
          padding: EdgeInsets.zero,
          children: <Widget>[
            DrawerHeader(
              decoration: BoxDecoration(
                color: Colors.black,
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  GestureDetector(
                    onTap: () {
                      _showImageWithZoom(context);
                    },
                    child: CircleAvatar(
                      radius: 50,
                      backgroundColor: Colors.white,
                      backgroundImage: _isLocalImage
                          ? FileImage(File(_currentImage))
                          : NetworkImage(_currentImage) as ImageProvider,
                    ),
                  ),
                  SizedBox(height: 10),
                  Text(
                    'Bienvenido al Museo Yismer',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
            _buildCircularListTile('Resources/perfil.jfif', 'Perfil', () {
              widget.onItemTap(0);
            }),
            _buildCircularListTile('Resources/youtube.png', 'Youtubers', () {
              widget.onItemTap(5);
            }),
            _buildCircularListTile('Resources/tik tok.png', 'Influencers', () {
              widget.onItemTap(6);
            }),
            _buildCircularListTile('Resources/twitch.jfif', 'Streamers', () {
              widget.onItemTap(7);
            }),
            _buildCircularListTile('Resources/maps.jfif', 'Convenciones', () {
              widget.onItemTap(2);
            }),
            _buildCircularListTile('Resources/busqueda.jfif', 'Búsqueda', () {
              widget.onItemTap(3);
            }),
            _buildCircularListTile('Resources/ajustes.png', 'Ajustes', () {
              widget.onItemTap(4);
            }),
            _buildCircularListTile('Resources/corazon.png', 'Favoritos', () {
              widget.onItemTap(8);
            }),
            _buildCircularListTile('Resources/logout.jfif', 'Cerrar Sesión', () {
              widget.onItemTap(1);
            }),
          ],
        ),
      ),
    );
  }

  Widget _buildCircularListTile(
      String imagePath, String title, VoidCallback onTap) {
    return ListTile(
      title: Center(
        child: Column(
          children: [
            CircleAvatar(
              radius: 24,
              backgroundColor: Colors.black,
              child: CircleAvatar(
                radius: 22,
                backgroundColor: Colors.white,
                backgroundImage: AssetImage(imagePath),
              ),
            ),
            SizedBox(height: 4),
            Text(
              title,
              style: TextStyle(color: Colors.black),
            ),
          ],
        ),
      ),
      onTap: onTap,
    );
  }
}
