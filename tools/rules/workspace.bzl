load("@bazel_tools//tools/build_defs/repo:utils.bzl",
    "patch",
    "workspace_and_buildfile",
)

def _impl(repository_ctx):
    archive = repository_ctx.attr.name + ".tar"
    reference = Label("@%s_unpatched//:README" % repository_ctx.attr.name)
    dirname = repository_ctx.path(reference).dirname

    # copy all file to currenty workspace
    repository_ctx.execute(["tar", "hcf", archive, "-C", dirname, "."])
    repository_ctx.extract(archive)
    repository_ctx.delete(archive)

    workspace_and_buildfile(repository_ctx)
    patch(repository_ctx)


_patched_rule = repository_rule(
    implementation = _impl,
    attrs = {
        "build_file": attr.label(allow_single_file=True),
        "build_file_content": attr.string(),
        "workspace_file": attr.label(allow_single_file=True),
        "workspace_file_content": attr.string(),
        "patches": attr.label_list(default=[]),
        "patch_args": attr.string_list(default=["-p0"])
    },
)

def new_patched_local_repository(name, path, **kwargs):
    native.new_local_repository(
        name = name + "_unpatched",
        build_file_content = """
filegroup(name="content", srcs=glob(["**"]))
""",
        path = path,
    )
    _patched_rule(name=name, **kwargs)
