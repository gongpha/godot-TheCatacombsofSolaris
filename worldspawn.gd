extends Spatial

onready var meshes : Spatial = $meshes
onready var character : KinematicBody = $character
onready var teleport : Spatial = $teleport
onready var overlay : Control = $overlay

var surface_mat := preload("res://resource/surface.tres")
export var global_texture : Texture

var mesh_tools := {}
var created : bool = false

func _capture(reset : bool = false, recycle : bool = true) :
	var image := get_viewport().get_texture().get_data()
	image.flip_y()
	var texture = ImageTexture.new()
	texture.create_from_image(image, global_texture.flags)
	surface_mat.albedo_texture = texture
	
	_teleport()
	
	var cam := get_viewport().get_camera()
	
	for m in meshes.get_children() :
		var mxform : Transform = m.global_transform
		var mesh := ArrayMesh.new()
		var orimesh : Mesh = m.mesh
		if orimesh is PrimitiveMesh :
			mesh.add_surface_from_arrays(Mesh.PRIMITIVE_TRIANGLES, m.mesh.get_mesh_arrays())
		else :
			mesh = orimesh
			
		var mdt : MeshDataTool = mesh_tools.get(m, null)
		if not mdt :
			mdt = MeshDataTool.new()
		
		if !(recycle and created) :
			mdt.clear()
			mdt.create_from_surface(mesh, 0)
		
		if reset :
			for i in range(mdt.get_vertex_count()) :
				var meta = mdt.get_vertex_meta(i)
				if meta is Vector2 :
					mdt.set_vertex_uv(i, meta)
		else :
			for i in range(mdt.get_vertex_count()) :
				var vertex := mdt.get_vertex(i)
				
				var screen : Vector2 = (
					cam.unproject_position(mxform.xform(vertex)) /
					texture.get_size()
				)
				if mdt.get_vertex_meta(i) == null :
					mdt.set_vertex_meta(i, mdt.get_vertex_uv(i))
				mdt.set_vertex_uv(i, screen)
			
		mesh.surface_remove(0)
		mdt.commit_to_surface(mesh)
		m.mesh = mesh
		mesh_tools[m] = mdt
	created = true

func _teleport() :
	character.global_transform = teleport.global_transform
	character.head.rotation = Vector3()
	
func _input(event) :
	if event is InputEventKey :
		if event.is_pressed() :
			if event.scancode == KEY_E :
				_capture()
				overlay.visible = false
			elif event.scancode == KEY_R :
				_capture(true)
				surface_mat.albedo_texture = global_texture
			elif event.scancode == KEY_T :
				overlay.visible = !overlay.visible
