import bpy
import ast

sim_data = open("/home/vfrenkel/ACADEMIC/parallel_programming/BioSwarm/bin/output.bswarm")

#pass through the first frame and initialize the actors.

sim_data.readline() #skip the first frame indicator.
for line in sim_data:
    #consider objects in first frame through entire sim.
    #break out of initializing loop when you hit next frame.
    if line.split(' ')[0] != "FRAME":
        tokens = line.split("; ")
        pos = ast.literal_eval(tokens[3].split("=")[1])
        #scene = bpy.data.scenes.active
        
        #extract position from position token and use it to place cube (firefly)
        identifier = ""
        #if tokens[0] == "ACTOR":
        identifier = "ACTOR_" + tokens[1].split("=")[1] + tokens[2].split("=")[1]
        bpy.ops.mesh.primitive_cube_add(location=pos)
        ob = bpy.context.object
        ob.name = identifier
        #ob.show_name = True
    else:
        break;

for line in sim_data:
    if "FRAME" in line:
        bpy.ops.anim.change_frame(frame=int(line.split(' ')[1]))
    else:
        tokens = line.split("; ")
        identifier = "ACTOR_" + tokens[1].split("=")[1] + tokens[2].split("=")[1]
        pos = ast.literal_eval(tokens[3].split("=")[1])

        ob = bpy.data.objects[identifier]
        #ob.select = True
        ob.location = pos
        bpy.ops.anim.keyframe_insert(type='Location')



