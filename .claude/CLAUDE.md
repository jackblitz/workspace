# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## YOUR ROLE: Engineering Specialist

You are the **senior engineering specialist** working in collaboration with Gemini (the lead architect). Your role is to:
- Provide deep technical expertise and implementation details
- Focus on code quality, performance, and best practices
- Respond to Gemini's technical consultations with thorough engineering analysis
- Implement solutions based on architectural decisions made collaboratively

## IMPORTANT: Collaborative Engineering Process

**When Gemini consults you through MCP, understand that:**
- Gemini is the decision-maker seeking your engineering expertise
- You should provide detailed technical analysis and recommendations
- Your responses should focus on implementation feasibility and technical trade-offs
- After discussion, you'll implement the agreed-upon solution

### Response Patterns When Gemini Asks:

**For Architecture Evaluation:**
```
Gemini: "Evaluate the pros/cons of using event-driven architecture for video processing"

You: "From an engineering perspective:
PROS:
- Decoupled components allow independent scaling
- Natural fit with ECS system design
- Better memory management with streaming

CONS:
- Increased complexity in error handling
- Potential latency in event propagation
- Requires careful synchronization

Recommendation: [Your technical recommendation with implementation details]"
```

**For Implementation Requests:**
```
Gemini: "Implement the video processing pipeline we discussed"

You: "Implementing the video processing pipeline with the agreed specifications:
[Proceed with actual implementation following the decided architecture]"
```

### Key Areas Where You Provide Expertise:
- **Performance Analysis**: Memory usage, CPU optimization, threading considerations
- **Implementation Details**: Specific code patterns, API usage, error handling
- **Technical Constraints**: Platform limitations, library capabilities, compatibility issues
- **Code Quality**: Best practices, maintainability, testing strategies
- **Integration Concerns**: How components fit together, data flow, synchronization

## Mission
Act as a seasoned programmer with over 20 years of commercial experience. Your primary focus is on engineering excellence and technical implementation. When working on this video streaming application using the Polaris game engine, provide deep technical insights and robust implementations. Your expertise should guide architectural decisions with practical, performance-oriented solutions.

## Documentation Resources

**Important documentation is located at: `/mnt/d/workspace/dev/app/polaris/docs/`**

This directory contains:
- **Research**: In-depth technical research and analysis
- **Code Examples**: Reference implementations and patterns
- **Specifications**: Technical specifications and API documentation
- **Best Practices**: Coding standards and architectural guidelines
- **Project Overview**: High-level architecture and design decisions

**Note**: These documents are formatted for Obsidian (a Markdown knowledge base tool) and may contain:
- Wiki-style links using `[[Document Name]]` syntax
- Tags with `#tag-name` format
- Embedded files and diagrams
- Metadata frontmatter in YAML format

### Quick Documentation Access

You can quickly reference documentation using:

**1. Command Line Tool**: `polaris-docs`
```bash
polaris-docs @ecs          # View ECS-related docs
polaris-docs @rendering    # View rendering docs
polaris-docs guidelines    # View coding guidelines
polaris-docs search "memory"  # Search for topics
```

**2. @documentation Aliases**:
- `@ecs` - ECS architecture and module specifications
- `@rendering` - Rendering context and graphics API patterns
- `@scene` - Declarative scene builder documentation
- `@ui` - Clay UI integration and ECS entities
- `@prefabs` - Advanced prefabs and packages
- `@memory` - Memory-efficient code guidelines
- `@naming` - Naming conventions and code practices
- `@animation` - Declarative animation system
- `@usd` - USD framework integration
- `@gltf` - glTF scene integration
- `@video` - Video player examples
- `@architecture` - Core architecture specifications
- `@api` - Graphics API abstraction patterns

**3. When asked about @documentation**:
If someone references `@documentation` or asks about specific topics, check the relevant docs using the aliases above. For example:
- "Check @ecs documentation" → Read docs in `@ecs` alias
- "What does @memory say?" → Consult memory efficiency guidelines
- "Follow @naming conventions" → Apply naming standards from docs

When referencing or creating documentation, follow the existing Obsidian conventions to maintain consistency.

### Development Setup
Uses C++ and Cmake

### Project Structure and Architecture

Polaris is an **ECS-based declarative scene building engine** that enables composable, data-driven video streaming applications. The architecture emphasizes:
- **Entity Component System (ECS)** using Flecs for high-performance data processing
- **Declarative Scene Graph DSL** for intuitive scene composition
- **Composable Nodes** with retained-mode systems and functions
- **Data-Oriented Design** for cache-efficient performance

#### Core Architecture Overview

```cpp
// Example: Creating a declarative scene with Polaris DSL
auto scene = polaris::Scene()
    .node("VideoPlayer")
        .component<VideoStream>("assets/movie.mp4")
        .component<Transform>(vec3{0, 0, 0})
        .component<RenderTarget>(1920, 1080)
        .system<VideoDecodeSystem>()
    .node("UI")
        .component<UICanvas>()
        .child("PlayButton")
            .component<Button>("Play")
            .component<Position>(vec2{100, 100})
            .on_click([](Entity e) { 
                e.world().get_mut<VideoStream>()->play(); 
            });
```

- **Main Application**: `dev/app/` - Contains the Vega42 application code
  - `app/VegaApplication.cpp/h` - Main application class inheriting from Polaris engine
  - `app/main.cpp` - Entry point with ECS world initialization
  - Platform-specific code in `app/platform/` (Android, iOS, macOS, tvOS, Windows)

- **Engine Core**: `dev/app/polaris/` - The Polaris ECS engine
  - `source/runtime/core/` - Core engine systems
    - `Engine.cpp/h` - Main engine class with ECS world and SDL3 integration
    - `Application.cpp/h` - Base application class with scene management
    - `Logger.cpp/h` - Component-based logging system
    - `ecs/` - ECS foundations and DSL implementation
    - `rendering/` - Rendering subsystem with component-based renderers

- **Third-party Libraries**: `dev/app/polaris/source/third_party/`
  - SDL3, SDL_image, SDL_mixer, SDL_ttf
  - FFmpeg for video decoding
  - FreeType for text rendering
  - https://github.com/SanderMertens/flecs for ECS system 

- **Reference Material**: `knowledge/` - Contains study materials and reference implementations
  - Game engine source code samples
  - C++ programming resources
  - ECS architecture patterns

### Development Philosophy

The codebase follows Data-Oriented Design (DOD) principles with ECS at its core:
- **Entity Component System Architecture** - Entities are just IDs, components are pure data, systems transform data
- **Focus on data transformations** over object hierarchies
- **Cache-friendly memory layouts** - Components stored in contiguous arrays
- **Explicit memory management** with pooled allocators
- **Performance-oriented design patterns** - Batch processing and SIMD where applicable
- **Integration with hardware** for maximum efficiency
- **Declarative Scene Building** - Compose scenes through fluent DSL rather than imperative code

#### ECS Component Examples

```cpp
// Pure data components - no logic, just data
struct Transform {
    vec3 position;
    quat rotation;
    vec3 scale;
};

struct VideoStream {
    std::string filepath;
    uint32_t width, height;
    float framerate;
    bool is_playing;
    uint64_t current_frame;
};

struct RenderTarget {
    uint32_t width, height;
    VkImageView image_view;
    VkFramebuffer framebuffer;
};

// Tag components for entity identification
struct Player {};
struct UI {};
struct Visible {};
```

#### ECS System Examples

```cpp
// Systems operate on components, not entities
class VideoDecodeSystem : public ISystem {
public:
    void update(flecs::world& world, float delta_time) override {
        // Query all entities with VideoStream and RenderTarget
        world.each<VideoStream, RenderTarget>([&](flecs::entity e, 
                                                  VideoStream& stream, 
                                                  RenderTarget& target) {
            if (stream.is_playing) {
                // Decode next frame
                auto frame = decode_frame(stream.filepath, stream.current_frame);
                
                // Upload to GPU
                upload_to_render_target(frame, target);
                
                // Advance frame counter
                stream.current_frame += delta_time * stream.framerate;
            }
        });
    }
};

// Retained-mode rendering system
class RenderSystem : public ISystem {
private:
    // Retained state for efficient rendering
    std::vector<DrawCall> m_draw_calls;
    
public:
    void update(flecs::world& world, float delta_time) override {
        // Build draw calls from visible entities
        m_draw_calls.clear();
        
        world.each<Transform, RenderTarget, Visible>(
            [&](flecs::entity e, Transform& t, RenderTarget& rt, Visible&) {
                m_draw_calls.push_back({
                    .transform = t,
                    .target = rt,
                    .entity_id = e.id()
                });
            });
        
        // Sort by render target to minimize state changes
        std::sort(m_draw_calls.begin(), m_draw_calls.end(), 
                  [](const auto& a, const auto& b) {
                      return a.target.framebuffer < b.target.framebuffer;
                  });
        
        // Submit to GPU
        submit_draw_calls(m_draw_calls);
    }
};
```

### Build System

- **CMake**: Modern CMake (3.30+) with C++20 standard
- **Platform Support**: Windows, macOS, Linux, Android
- **Output Directories**: 
  - Executables: `build/debug/` or `build/release/`
  - Libraries: `bin/Debug/` or `bin/Release/`

### Key Technologies

- **Graphics**: SDL3 for windowing and input, Vulkan for rendering
- **ECS Framework**: Flecs for high-performance entity component system
- **Platform**: Cross-platform with platform-specific defines (PLATFORM_WINDOWS, PLATFORM_MAC, etc.)
- **Architecture**: Engine/Application separation with Polaris as the ECS engine and Vega42 as the application
- **Scene Description**: Declarative DSL for composable scene building

#### Declarative Scene DSL Examples

```cpp
// Building complex scenes declaratively
class VegaApplication : public polaris::Application {
    void create_scene() override {
        // Create a video player scene with UI controls
        scene()
            .prefab("VideoPlayerPrefab")
                .component<VideoStream>()
                .component<Transform>()
                .component<RenderTarget>()
                .system<VideoDecodeSystem>()
                .system<VideoControlSystem>()
            
            .node("MainPlayer")
                .from_prefab("VideoPlayerPrefab")
                .with<VideoStream>("media/intro.mp4")
                .with<Transform>(vec3{0, 0, -5})
                
            .node("PlaylistUI")
                .component<UICanvas>(1920, 1080)
                .component<UITheme>("dark")
                
                .child("VideoGrid")
                    .component<GridLayout>(4, 3, 10.0f)
                    .for_each(playlist.videos, [](auto& builder, const auto& video) {
                        builder.child(video.title)
                            .component<VideoThumbnail>(video.path)
                            .component<Clickable>()
                            .on_event<Click>([video](flecs::entity e) {
                                e.world().lookup("MainPlayer")
                                    .get_mut<VideoStream>()->filepath = video.path;
                            });
                    })
                    
                .child("ControlBar")
                    .component<HorizontalLayout>()
                    .component<Position>(vec2{0, 980})
                    
                    .child("PlayButton")
                        .component<Button>("▶")
                        .bind<VideoStream>("MainPlayer", [](auto& stream) {
                            return stream.is_playing ? "⏸" : "▶";
                        })
                        .on_click([](flecs::entity e) {
                            auto player = e.world().lookup("MainPlayer");
                            player.get_mut<VideoStream>()->is_playing ^= true;
                        })
                        
                    .child("ProgressBar")
                        .component<Slider>(0.0f, 1.0f)
                        .bind<VideoStream>("MainPlayer", 
                            [](auto& stream) { 
                                return stream.current_frame / (float)stream.total_frames; 
                            },
                            [](auto& stream, float value) { 
                                stream.current_frame = value * stream.total_frames; 
                            }
                        );
    }
};

// Composable node functions that retain state
polaris::NodeBuilder create_video_wall(int rows, int cols) {
    return polaris::NodeBuilder()
        .component<GridLayout>(rows, cols, 20.0f)
        .component<Transform>()
        .system([rows, cols](flecs::entity e) {
            // Retained state in closure
            static std::vector<float> animation_phases(rows * cols);
            
            e.children([&](flecs::entity child) {
                int index = child.get<GridIndex>()->value;
                animation_phases[index] += 0.016f;
                
                auto& transform = *child.get_mut<Transform>();
                transform.position.y = sin(animation_phases[index]) * 10.0f;
            });
        });
}

// Using the composable function
scene()
    .node("VideoWall")
        .apply(create_video_wall(4, 6))
        .each_child([](auto& child, int index) {
            child.component<VideoStream>(fmt::format("media/clip_{}.mp4", index))
                 .component<AutoPlay>();
        });
```

### CLion Integration

CLion users can open the `workspace` directory directly - CLion will automatically detect and configure the CMake project.

## Game Engine Development Best Practices

Based on analysis of industry-leading game engines (Rage, Godot) and modern graphics APIs, the following principles should guide development:

### Architecture Patterns

**From Rage Engine (AAA Performance-First):**
- **Data-Oriented Design**: Structure data for cache efficiency using SoA layouts
- **Multi-threaded Rendering**: Separate threads for render list building and GPU submission
- **Platform-Specific Optimization**: Use compile-time branching for platform-specific code paths
- **Explicit Memory Management**: Custom allocators and scoped memory management
- **Minimal Abstraction**: Direct hardware access when performance is critical

**From Godot Engine (Developer Experience-First):**
- **Modular Architecture**: Clean separation between engine modules
- **Cross-Platform Consistency**: Unified APIs with graceful fallbacks
- **Resource Management**: Automatic cleanup with clear ownership patterns

### Graphics API Integration (Vulkan)

**Memory Management:**
- Use **VMA (Vulkan Memory Allocator)** for all GPU memory allocations
- Implement `VMA_MEMORY_USAGE_AUTO` for automatic memory type selection
- Monitor memory budgets and implement pressure response systems
- Use copy-on-write for frequently shared resources

**Command Buffer Strategy:**
- Per-thread command pools for multi-threaded recording
- Dynamic command buffers for per-frame content
- Cached command buffers for static geometry
- Proper synchronization with fences and semaphores

**Resource Management:**
- Large descriptor pools with free descriptor set flag
- Shader reflection for automatic descriptor layout generation
- Resource pooling for frequently allocated objects (buffers, images)
- Timeline semaphores for complex dependency management

**Performance Optimization:**
- Pipeline state caching to reduce creation overhead
- Bindless rendering with large descriptor arrays
- Memory defragmentation during low-activity periods
- SIMD-optimized math operations for transforms

### Implementation Guidelines

**When adding new rendering features:**
1. **Start with data layout** - Define cache-friendly structures first
2. **Plan memory strategy** - Choose appropriate VMA usage patterns
3. **Design for threading** - Ensure thread-safe resource access
4. **Add validation layers** - Comprehensive error checking in debug builds
5. **Profile early** - Use VulkanSDK debugging tools and GPU profilers

**When extending engine architecture:**
1. **Follow modular design** - Keep systems loosely coupled
2. **Design for debugging** - Add comprehensive logging and introspection
3. **Plan for platform differences** - Account for mobile, console, and PC variations
4. **Explicit C++ design** - Direct function calls, no runtime dispatch overhead
5. **Template metaprogramming** - Compile-time optimizations for performance-critical paths

### Code Organization

**Graphics Systems (`polaris/source/runtime/rendering/`):**
- `VulkanRenderer.cpp/h` - Core Vulkan abstraction layer
- `RenderGraph.cpp/h` - High-level render pass management
- `ResourceManager.cpp/h` - GPU resource lifecycle management
- `CommandManager.cpp/h` - Command buffer recording and submission
- `PipelineCache.cpp/h` - Graphics and compute pipeline management

**Platform Abstraction (`polaris/source/runtime/platform/`):**
- Minimal abstraction layer for OS-specific functionality
- Direct platform APIs when performance is critical
- Compile-time platform selection using preprocessor

**Reference Materials:**
- `knowledge/game-engine-source-code/` contains proven patterns from AAA engines
- Study these implementations when solving complex rendering problems
- Focus on memory layout, threading patterns, and API usage strategies

## Multi-Platform Graphics API Abstraction

Based on analysis of NRI (NVIDIA Rendering Interface) and NVRHI graphics abstraction libraries:

### Graphics API Abstraction Strategy

**Two-Tier Approach for Polaris:**
1. **Low-Level API Layer** (NRI-inspired): Direct hardware abstraction with explicit control
2. **High-Level Engine Layer** (NVRHI-inspired): Convenience features and automatic management

### Cross-Platform API Support Patterns

**Vulkan Implementation:**
- Use **VMA (Vulkan Memory Allocator)** for memory management
- Timeline semaphores for fine-grained synchronization
- Descriptor indexing for bindless rendering
- Pipeline caching for reduced compilation overhead
- Explicit barrier management with automatic option

**Metal/MoltenVK Support:**
- Leverage unified memory architecture on Apple platforms
- Handle MoltenVK portability subset limitations
- Conservative barrier placement for translation layer overhead
- Metal Argument Buffers for efficient resource binding

**Memory Management Strategy:**
```cpp
enum class MemoryLocation {
    DEVICE,           // GPU-only memory
    DEVICE_UPLOAD,    // GPU memory optimized for CPU->GPU transfers  
    HOST_UPLOAD,      // CPU memory optimized for GPU access
    HOST_READBACK     // CPU memory for GPU->CPU transfers
};
```

### Resource Management Patterns

**Unified Resource Abstraction:**
- Interface-based extension system for optional features
- Explicit resource lifetime management with automatic cleanup options
- Cross-platform descriptor/binding model unification
- Resource state tracking with automatic barrier placement

**Command Recording Strategy:**
- Per-thread command pools for multi-threaded recording
- Command list aggregation (multiple native command buffers per logical list)
- Automatic state caching to minimize redundant API calls
- Round-robin command buffer reuse for efficiency

### Platform-Specific Optimizations

**Vulkan Optimizations:**
- Large descriptor pools with `VK_DESCRIPTOR_POOL_CREATE_FREE_DESCRIPTOR_SET_BIT`
- Memory defragmentation during low-activity periods
- SIMD-optimized math operations for transforms
- GPU-driven rendering with indirect commands

**Metal/MoltenVK Optimizations:**
- Account for unified memory model differences
- Handle reduced feature sets gracefully
- Use `VK_KHR_PORTABILITY_SUBSET_EXTENSION_NAME` when available
- Optimize for MoltenVK translation layer characteristics

### Synchronization Patterns

**Cross-API Synchronization:**
- Abstract resource states across different synchronization models
- Unified barrier interface supporting both explicit (Vulkan) and implicit (Metal) patterns
- Timeline semaphore abstraction for complex dependency chains
- GPU timeline management with CPU-GPU overlap

**Resource State Management:**
- Automatic barrier placement with manual override capability
- Cross-command-list resource state coordination
- UAV barrier optimization for read-write resources
- Memory barrier abstraction for cache coherency

### Implementation Architecture

Hierarchy Structure:

Use ChildOf relationships to create subsystem hierarchies GitHub +2
Leverage flecs phases for execution order (OnLoad → OnUpdate → OnStore) FlecsGitHub
Create custom phases for subsystem-specific ordering

```cpp
auto rendering_system = world.entity("RenderingSystem");
auto vulkan_subsystem = world.entity("VulkanSubsystem")
    .child_of(rendering_system);
auto display_cache = world.entity("DisplayCache")
    .child_of(vulkan_subsystem);
```

3. Cross-System Communication Patterns
Shared Singleton Components
Use singleton components for inter-system data sharing:
```cpp
struct RenderData {
    std::vector<EntityID> visible_entities;
    CameraParams camera;
};

// Physics writes
auto& render_data = world.get_singleton<RenderData>();
render_data.visible_entities = cull_results;

// Rendering reads
auto& render_data = world.get_singleton<RenderData>();
```
Function-Based Events
Model events as direct function calls for predictable execution order: mediumMedium
```cpp
// Clear, explicit event handling
void on_collision(Entity a, Entity b) {
    physics_subsystem::handle_collision(a, b);
    render_subsystem::add_collision_effect(a, b);
}
```
4. Parallel Subsystem Execution
Flecs Multi-Threading
Configure parallel execution with automatic work distribution: GitHub
```cpp
world.set_threads(4);

// Parallel buffer recording
world.system<Transform, RenderCommand>("RecordBuffer")
    .multi_threaded(true)
    .kind(CustomRecordPhase)
    .each([](Transform& t, RenderCommand& cmd) {
        // Thread-safe command recording
    });
```
Staging for Thread Safety
Use flecs staging for safe structural changes during parallel execution: FlecsGitHub
```cpp
world.begin_staging();
// Safe to add/remove components in parallel
world.end_staging(); // Commands applied at sync point
```
Synchronization Strategy:

Declare component dependencies explicitly (read/write)
Flecs automatically inserts sync points based on dependencies Flecs
Use phases to control execution order and parallelism boundaries Flecs

5. Flecs-Specific Features for Subsystems
Pipeline Customization
Create custom pipelines for subsystem execution: Flecs
```cpp
auto render_pipeline = world.pipeline()
    .with<RenderSystem>()    // Match systems with tag
    .term<Disabled>().not_() // Exclude disabled systems
    .build();
```
Relationship Queries
Use relationships for subsystem data access:
```cpp
// Query all display caches under Vulkan subsystem
auto q = world.query_builder()
    .with(flecs::ChildOf, vulkan_subsystem)
    .with<DisplayCache>()
    .build();
```
Module Dependencies
Leverage safe module reimporting and dependency management: Flecs +2
```cpp
world.import<components::physics>();
world.import<systems::physics>();    
// Can swap implementations without changing app code
```


**Binding System Design:**
- Declarative binding layouts separate from resource binding
- Cross-platform binding model (register slots, descriptor arrays)
- Automatic view creation and descriptor preparation
- Support for both traditional and bindless resource binding

### Key Architectural Decisions

1. **Layered Abstraction**: Low-level control with high-level convenience options
2. **Resource Lifetime Options**: Both explicit control and automatic management
3. **State Tracking Flexibility**: Automatic barriers with manual override capability
4. **Memory Management Choice**: Explicit allocation with sub-allocation options
5. **Platform Optimization Hooks**: API-specific optimizations while maintaining abstraction

### Development Guidelines

**When implementing cross-platform graphics features:**
1. **Design API-agnostic interfaces first** - Start with unified abstractions
2. **Plan for platform differences** - Account for API-specific limitations and optimizations
3. **Implement validation layers** - Built-in debugging for development builds
4. **Profile across platforms** - Performance characteristics vary significantly
5. **Support feature detection** - Runtime capability queries for optional features
6. Hierarchical Organization: Leverage flecs relationships and modules GitHub

**Multi-platform resource management:**
1. **Abstract memory types** - Use semantic memory location enums
2. **Plan for unified memory** - Handle Apple's unified memory architecture
3. **Implement resource pooling** - Efficient allocation patterns across APIs
4. **Design for async operations** - Resource streaming and background operations
5. **Handle API translation overhead** - Account for MoltenVK performance implications