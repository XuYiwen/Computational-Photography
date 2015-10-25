# CS 445 Computational Photography  https://courses.engr.illinois.edu/cs445/
# Project 4: Image-based Lighting

import bpy
from os import path


def is_plane(obj):
    """
    :return: True if the given object's mesh has exactly 4 vertices and edges.
    """
    mesh = obj.data
    return hasattr(mesh, 'edges') and hasattr(mesh, 'vertices') and len(
        mesh.edges) == 4 and len(mesh.vertices) == 4


def foreground_objects():
    """
    :return: List of all renderable objects excluding any plane(s).
    """
    foreground = []
    for obj in bpy.data.objects:
        if (not hasattr(obj.data, 'materials') or is_plane(obj) or
                issubclass(type(obj.data), bpy.types.Lamp)):
            continue
        foreground.append(obj)
    return foreground


def render_and_save(png_filename, out_dir='./'):
    """
    Renders the scene (using the currently selected rendering engine)
    and saves the image.

    :param png_path: Path to output image
    """
    from os import path
    out_path = path.join(path.expanduser(out_dir), png_filename)
    bpy.ops.render.render()
    bpy.data.images['Render Result'].save_render(filepath=out_path)


def object_mask_mode():
    """
    Removes all existing materials and assigns a mask.
    """

    def create_mask(name='MaskMaterial', rgb=(1.0, 1.0, 1.0)):
        mask = bpy.data.materials.new(name)
        mask.specular_color = rgb
        mask.specular_intensity = 1.0
        mask.use_shadeless = True
        return mask

    # Uses Blender Renderer
    bpy.context.scene.render.engine = 'BLENDER_RENDER'
    bpy.ops.object.mode_set(mode='OBJECT')

    # Create a mask material.
    mask = create_mask()
    for obj in foreground_objects():
        obj.data.materials.clear()
        obj.data.materials.append(mask)
        print('Assigning mask material to {}'.format(obj.data.name))
        obj.hide_render = False

    # Sets Horizon RGB color to black.
    bpy.context.scene.world.horizon_color = (0, 0, 0)


def object_rendering_mode(environment_texture_path,
                          hide_objects=False,
                          background_strength=0.01,
                          surface_rgba=(0.367, 0.310, 0.298, 1.0)):
    """
    Prepares the scene for rendering with Cycles renderer.

    :param hide_objects: If true, only the plane surface will be visible.
    :param environment_texture_path: Path to environment texture image.
    :param background_strength: Environment light intensity.
    :param surface_rgba: Color of the plane.
    """
    bpy.context.scene.render.engine = 'CYCLES'
    bpy.ops.object.mode_set(mode='OBJECT')

    for obj in foreground_objects():
        obj.hide_render = hide_objects

    for obj in bpy.data.objects:
        if is_plane(obj) and obj.active_material is not None:
            node = obj.active_material.node_tree.nodes['Diffuse BSDF']
            node.inputs['Color'].default_value = surface_rgba

    world_background = bpy.context.scene.world.node_tree.nodes['Background']
    world_background.inputs['Strength'].default_value = background_strength

    image = bpy.data.images.load(environment_texture_path)
    environment_texture = world_background.inputs['Color'].links[0].from_node
    environment_texture.image = image

## Blender script starts here.

# Change this path:
project_path = '/path/to/proj4_materials/'

# Path to the HDR image.
environment_texture = path.join(project_path, 'latlon.hdr')

# Saves before rendering.
bpy.ops.wm.save_mainfile()

try:
    print('Rendering objects.')
    object_rendering_mode(environment_texture_path=environment_texture)
    render_and_save('objects.png', out_dir=project_path)

    print('Rendering without objects.')
    object_rendering_mode(hide_objects=True,
                          environment_texture_path=environment_texture)
    render_and_save('without_objects.png', out_dir=project_path)

    print('Rendering object mask.')
    object_mask_mode()  # This step will remove all foreground object materials.
    render_and_save('mask.png', out_dir=project_path)

    print('Done')

finally:
    # Reverts back to the last saved state.
    bpy.ops.wm.revert_mainfile()
