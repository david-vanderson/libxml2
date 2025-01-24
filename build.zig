const std = @import("std");

/// Compile-time options for the library. These mostly correspond to
/// options exposed by the native build system used by the library.
pub const Options = struct {
    // These options are all defined in libxml2's configure.c and correspond
    // to `--with-X` options for `./configure`. Their defaults are properly set.
    c14n: bool = true,
    catalog: bool = true,
    debug: bool = true,
    ftp: bool = false,
    history: bool = true,
    html: bool = true,
    iconv: bool = false,
    icu: bool = false,
    iso8859x: bool = true,
    legacy: bool = false,
    mem_debug: bool = false,
    minimum: bool = true,
    output: bool = true,
    pattern: bool = true,
    push: bool = true,
    reader: bool = true,
    regexp: bool = true,
    run_debug: bool = false,
    sax1: bool = true,
    schemas: bool = true,
    schematron: bool = true,
    thread: bool = true,
    thread_alloc: bool = false,
    tree: bool = true,
    valid: bool = true,
    writer: bool = true,
    xinclude: bool = true,
    xpath: bool = true,
    xptr: bool = true,
    xptr_locs: bool = false,
    modules: bool = true,
    lzma: bool = false,
    zlib: bool = true,
};

pub fn build(b: *std.Build) !void {
    const target = b.standardTargetOptions(.{});
    const optimize = b.standardOptimizeOption(.{});

    const lib = b.addStaticLibrary(.{
        .name = "xml2",
        .target = target,
        .optimize = optimize,
    });

    const config_header = b.addConfigHeader(.{
        .style = .{ .cmake = b.path("config.h.cmake.in") },
        .include_path = "config.h",
    }, .{
        .ATTRIBUTE_DESTRUCTOR = "__attribute__((destructor))",
        .HAVE_ARPA_INET_H = 1,
        .HAVE_DLFCN_H = 1,
        .HAVE_DLOPEN = 1,
        .HAVE_DL_H = 1,
        .HAVE_FCNTL_H = 1,
        .HAVE_FTIME = 1,
        .HAVE_GETTIMEOFDAY = 1,
        .HAVE_INTTYPES_H = 1,
        .HAVE_ISASCII = 1,
        .HAVE_LIBHISTORY = 1,
        .HAVE_LIBREADLINE = 1,
        .HAVE_MMAP = 1,
        .HAVE_MUNMAP = 1,
        .HAVE_NETDB_H = 1,
        .HAVE_NETINET_IN_H = 1,
        .HAVE_POLL_H = 1,
        .HAVE_PTHREAD_H = 1,
        .HAVE_PUTENV = 1,
        .HAVE_RAND_R = 1,
        .HAVE_SHLLOAD = 1,
        .HAVE_STAT = 1,
        .HAVE_STDINT_H = 1,
        .HAVE_SYS_MMAN_H = 1,
        .HAVE_SYS_SELECT_H = 1,
        .HAVE_SYS_SOCKET_H = 1,
        .HAVE_SYS_STAT_H = 1,
        .HAVE_SYS_TIMEB_H = 1,
        .HAVE_SYS_TIME_H = 1,
        .HAVE_UNISTD_H = 1,
        .HAVE_VA_COPY = 1,
        .HAVE_ZLIB_H = 1,
        .HAVE___VA_COPY = 1,
        .PACKAGE = "libxml2",
        .PACKAGE_BUGREPORT = "xml@gnome.org",
        .PACKAGE_NAME = "libxml2",
        .PACKAGE_STRING = "libxml2 2.10.0-dev",
        .PACKAGE_TARNAME = "libxml2",
        .PACKAGE_URL = "https://github.com/david-vanderson/libxml2",
        .PACKAGE_VERSION = "2.10.0-dev",
        .LT_OBJDIR = ".libs/",
        .SUPPORT_IP6 = 1,
        .VA_LIST_IS_ARRAY = 1,
        .XML_SOCKLEN_T = .socklen_t,
        .VERSION = "2.10.0-dev",
    });

    lib.addConfigHeader(config_header);
    lib.installConfigHeader(config_header);

    const opts: Options = .{};

    var flags = std.ArrayList([]const u8).init(b.allocator);
    defer flags.deinit();

    try flags.appendSlice(&.{
        // Version info, hardcoded
        "-DLIBXML_VERSION=21000",
        "-DLIBXML_VERSION_STRING=\"21000\"",
        "-DLIBXML_VERSION_EXTRA=\"\"",
        "-DLIBXML_XPATH_ENABLED=1",
        "-DXML_IGNORE_FPTR_CAST_WARNINGS=",
        "-DXML_POP_WARNINGS=",

        // These might now always be true (particularly Windows) but for
        // now we just set them all. We should do some detection later.
        "-DSEND_ARG2_CAST=",
        "-DGETHOSTBYNAME_ARG_CAST=",
        "-DGETHOSTBYNAME_ARG_CAST_CONST=",

        // Always on
        "-DLIBXML_STATIC=1",
        "-DLIBXML_AUTOMATA_ENABLED=1",
        "-DWITHOUT_TRIO=1",
    });

    if (target.result.os.tag != .windows) {
        try flags.appendSlice(&.{
            "-DHAVE_ARPA_INET_H=1",
            "-DHAVE_ARPA_NAMESER_H=1",
            "-DHAVE_DL_H=1",
            "-DHAVE_NETDB_H=1",
            "-DHAVE_NETINET_IN_H=1",
            "-DHAVE_PTHREAD_H=1",
            "-DHAVE_SHLLOAD=1",
            "-DHAVE_SYS_DIR_H=1",
            "-DHAVE_SYS_MMAN_H=1",
            "-DHAVE_SYS_NDIR_H=1",
            "-DHAVE_SYS_SELECT_H=1",
            "-DHAVE_SYS_SOCKET_H=1",
            "-DHAVE_SYS_TIMEB_H=1",
            "-DHAVE_SYS_TIME_H=1",
            "-DHAVE_SYS_TYPES_H=1",
        });
    }

    if (opts.mem_debug) {
        try flags.append("-DDEBUG_MEMORY_LOCATION=1");
    }
    if (opts.regexp) {
        try flags.append("-DLIBXML_UNICODE_ENABLED=1");
    }
    if (opts.run_debug) {
        try flags.append("-DLIBXML_DEBUG_RUNTIME=1");
    }
    if (opts.thread) {
        try flags.append("-DHAVE_LIBPTHREAD=1");
    }

    // Enable our `./configure` options. For bool-type fields we translate
    // it to the `LIBXML_{field}_ENABLED` C define where field is uppercased.
    inline for (std.meta.fields(@TypeOf(opts))) |field| {
        if (field.type == bool and @field(opts, field.name)) {
            var nameBuf: [32]u8 = undefined;
            const name = std.ascii.upperString(&nameBuf, field.name);
            const define = try std.fmt.allocPrint(b.allocator, "-DLIBXML_{s}_ENABLED=1", .{name});
            try flags.append(define);
        }
    }

    lib.addCSourceFiles(.{ .files = srcs, .flags = flags.items });

    lib.addIncludePath(b.path("include"));
    lib.addIncludePath(b.path("build_zig_include"));
    if (target.result.os.tag == .windows) {
        lib.linkSystemLibrary("ws2_32");
    }
    lib.linkLibC();

    const libz_dep = b.dependency("libz", .{
        .target = target,
        .optimize = optimize,
    });
    lib.linkLibrary(libz_dep.artifact("z"));

    b.installArtifact(lib);
    lib.installHeadersDirectory(b.path("include"), "", .{});
    lib.installHeader(b.path("build_zig_include/libxml/xmlversion.h"), "libxml/xmlversion.h");
}

const srcs = &.{
    "buf.c",
    "c14n.c",
    "catalog.c",
    "chvalid.c",
    "debugXML.c",
    "dict.c",
    "encoding.c",
    "entities.c",
    "error.c",
    "globals.c",
    "hash.c",
    "HTMLparser.c",
    "HTMLtree.c",
    "legacy.c",
    "list.c",
    "nanoftp.c",
    "nanohttp.c",
    "parser.c",
    "parserInternals.c",
    "pattern.c",
    "relaxng.c",
    "SAX.c",
    "SAX2.c",
    "schematron.c",
    "threads.c",
    "tree.c",
    "uri.c",
    "valid.c",
    "xinclude.c",
    "xlink.c",
    "xmlIO.c",
    "xmlmemory.c",
    "xmlmodule.c",
    "xmlreader.c",
    "xmlregexp.c",
    "xmlsave.c",
    "xmlschemas.c",
    "xmlschemastypes.c",
    "xmlstring.c",
    "xmlunicode.c",
    "xmlwriter.c",
    "xpath.c",
    "xpointer.c",
    "xzlib.c",
};
