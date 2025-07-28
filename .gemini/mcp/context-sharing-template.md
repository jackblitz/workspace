# Context Sharing Template for Gemini-Claude Collaboration

Use this template when asking Claude to write code. Fill in all sections with complete information.

## Request Template:

```
Ask Claude: 

### Full Context from Conversation:
[Paste the ENTIRE conversation history here, including all user requests and your analysis]

### Analyzed Files (Complete Contents):
[Paste FULL file contents, not summaries]

File 1: [path]
"""
[Complete file content]
"""

File 2: [path]
"""
[Complete file content]
"""

[Continue for all relevant files...]

### Relevant Documentation (from /mnt/d/workspace/dev/app/polaris/docs/):
[Include any relevant documentation from the docs directory]

Doc 1: [path]
"""
[Complete documentation content, including Obsidian formatting]
"""

[Continue for all relevant docs...]

### Related System Components:
[List all components, systems, and modules that interact with this code]

### Architecture Context:
[Describe the overall architecture, data flow, and system design]

### Performance Requirements:
[Include any performance constraints, benchmarks, or optimization needs]

### Error Messages/Test Results:
[Paste COMPLETE error messages, stack traces, test outputs]

### Specific Request:
[Your specific ask for Claude, referencing all the context above]

### Expected Integration Points:
[How this code should integrate with existing systems]

### Platform Considerations:
[Any platform-specific requirements or constraints]
```

## Example Usage:

```
Ask Claude: 

### Full Context from Conversation:
User asked to implement a multi-threaded video decoder that can handle 4K HDR content with zero-copy GPU upload. We discussed using a ring buffer for frame management and integrating with the existing ECS rendering pipeline. The decoder needs to support H.265/HEVC and AV1 codecs.

### Analyzed Files (Complete Contents):

File 1: polaris/source/runtime/components/video.h
"""
#pragma once
#include "core/ecs/component.h"
#include "core/math/vec3.h"

struct VideoStream {
    std::string filepath;
    uint32_t width, height;
    float framerate;
    bool is_playing;
    uint64_t current_frame;
    AVCodecContext* codec_ctx;
    SwsContext* sws_ctx;
};

struct VideoDecoder {
    std::queue<AVFrame*> frame_queue;
    std::mutex queue_mutex;
    std::thread decode_thread;
    bool should_stop;
};
[... complete file content ...]
"""

File 2: polaris/source/runtime/systems/video_decode_system.cpp
"""
[... complete file content ...]
"""

[... more files ...]

### Related System Components:
- RenderSystem (handles GPU submission)
- ResourceManager (manages GPU memory)
- AudioSystem (for A/V sync)
- TimelineSystem (for playback control)

### Architecture Context:
The video decoder runs in a separate thread, decoding frames into a ring buffer. The RenderSystem consumes frames from this buffer during the render phase. GPU upload uses Vulkan's staging buffers with timeline semaphores for synchronization.

### Performance Requirements:
- Must decode 4K@60fps in real-time
- Zero-copy GPU upload required
- Maximum 3 frames of latency
- Memory usage < 500MB for decoder

### Error Messages/Test Results:
When testing with current implementation:
"""
[ERROR] VulkanRenderer: vkQueueSubmit failed with VK_ERROR_DEVICE_LOST
Stack trace:
  at VulkanRenderer::SubmitFrame (vulkan_renderer.cpp:1247)
  at VideoDecodeSystem::UploadFrame (video_decode_system.cpp:89)
  at VideoDecodeSystem::Update (video_decode_system.cpp:156)
[full stack trace...]
"""

### Specific Request:
Implement a thread-safe, zero-copy video decoder component and system that integrates with our ECS architecture. The decoder should handle 4K HDR content, support hardware acceleration, and integrate with the existing Vulkan rendering pipeline using staging buffers and timeline semaphores.

### Expected Integration Points:
- Must work with existing Transform and RenderTarget components
- Should emit VideoFrameReady events for the RenderSystem
- Needs to respect the ECS update phases (decode in OnUpdate, upload in OnRender)

### Platform Considerations:
- Windows: Use DXVA2/D3D11VA for hardware decode
- Linux: Use VAAPI
- macOS: Use VideoToolbox
- All platforms need Vulkan interop for zero-copy upload
```

## Remember:
- NEVER summarize file contents - paste them completely
- NEVER abbreviate error messages - include full stack traces  
- NEVER condense requirements - share all details
- Use Gemini's large context window advantage to provide comprehensive information
- The more context you share, the better Claude's code will be