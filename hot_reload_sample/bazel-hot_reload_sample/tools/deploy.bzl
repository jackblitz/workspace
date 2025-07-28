"""Rules for deploying outputs to clean directories."""

def _deploy_binary_impl(ctx):
    """Implementation of deploy_binary rule."""
    output_dir = ctx.actions.declare_directory(ctx.attr.output_dir)
    
    # Create a script to copy files
    script_content = []
    script_content.append("#!/bin/bash")
    script_content.append("set -e")
    script_content.append("mkdir -p " + output_dir.path)
    
    # Copy each source file to the output directory
    for src in ctx.files.srcs:
        dst_name = src.basename
        if ctx.attr.rename and src.basename in ctx.attr.rename:
            dst_name = ctx.attr.rename[src.basename]
        script_content.append("cp -f " + src.path + " " + output_dir.path + "/" + dst_name)
    
    # Create the deployment script
    script = ctx.actions.declare_file(ctx.label.name + "_deploy.sh")
    ctx.actions.write(
        output = script,
        content = "\n".join(script_content),
        is_executable = True,
    )
    
    # Run the deployment script
    ctx.actions.run(
        outputs = [output_dir],
        inputs = ctx.files.srcs,
        executable = script,
        tools = [script],
        mnemonic = "Deploy",
        progress_message = "Deploying %s" % ctx.label,
    )
    
    return [DefaultInfo(files = depset([output_dir]))]

deploy_binary = rule(
    implementation = _deploy_binary_impl,
    attrs = {
        "srcs": attr.label_list(allow_files = True),
        "output_dir": attr.string(mandatory = True),
        "rename": attr.string_dict(),
    },
)