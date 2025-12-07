    <script lang="ts">
//  <script lang="ts">




    import { onMount, onDestroy, } from "svelte";
//  import { onMount, onDestroy, } from "svelte";




    let _adapter: GPUAdapter;
//  let _adapter: GPUAdapter;
    let _device: GPUDevice;
//  let _device: GPUDevice;
    let _canvas: HTMLCanvasElement;
//  let _canvas: HTMLCanvasElement;
    let _canvasContext: GPUCanvasContext;
//  let _canvasContext: GPUCanvasContext;
    let _presentationFormat: GPUTextureFormat;
//  let _presentationFormat: GPUTextureFormat;
    let _backgroundShaderModule: GPUShaderModule;
//  let _backgroundShaderModule: GPUShaderModule;
    let _backgroundShaderString: string;
//  let _backgroundShaderString: string;
    let _backgroundBindGroupLayout0: GPUBindGroupLayout | null;
//  let _backgroundBindGroupLayout0: GPUBindGroupLayout | null;
    let _backgroundPipelineLayout: GPUPipelineLayout | "auto";
//  let _backgroundPipelineLayout: GPUPipelineLayout | "auto";
    let _backgroundPipeline: GPURenderPipeline;
//  let _backgroundPipeline: GPURenderPipeline;
    let _commandEncoderDescriptor: GPUCommandEncoderDescriptor;
//  let _commandEncoderDescriptor: GPUCommandEncoderDescriptor;
    let _backgroundPassDescriptor: GPURenderPassDescriptor;
//  let _backgroundPassDescriptor: GPURenderPassDescriptor;
    let _commandEncoder: GPUCommandEncoder;
//  let _commandEncoder: GPUCommandEncoder;
    let _backgroundPass: GPURenderPassEncoder;
//  let _backgroundPass: GPURenderPassEncoder;
    let _commandBuffer: GPUCommandBuffer;
//  let _commandBuffer: GPUCommandBuffer;
    /*
//  /*
    let _resizeObserver: ResizeObserver;
//  let _resizeObserver: ResizeObserver;
    */
//  */
    let _dataUniformValues: Float32Array;
//  let _dataUniformValues: Float32Array;
    let _dataUniformBuffer: GPUBuffer;
//  let _dataUniformBuffer: GPUBuffer;
    let _backgroundBindGroup0: GPUBindGroup;
//  let _backgroundBindGroup0: GPUBindGroup;
    let _isRunningLoop: boolean;
//  let _isRunningLoop: boolean;
    let _frameHandleLoop: number;
//  let _frameHandleLoop: number;
    let _time: number;
//  let _time: number;




    const initOnce = async (): Promise<void> => {
//  const initOnce = async (): Promise<void> => {
        _backgroundShaderString = await (await fetch(`/shadertoy.3lf3z2.wgsl`)).text();
//      _backgroundShaderString = await (await fetch(`/shadertoy.3lf3z2.wgsl`)).text();
        _adapter = (await navigator.gpu.requestAdapter())!;
//      _adapter = (await navigator.gpu.requestAdapter())!;
        _device = await _adapter.requestDevice({
//      _device = await _adapter.requestDevice({
            requiredFeatures: [
//          requiredFeatures: [
            ] as Iterable<GPUFeatureName>,
//          ] as Iterable<GPUFeatureName>,
            requiredLimits: {
//          requiredLimits: {
            },
//          },
        });
//      });
        _canvasContext = _canvas.getContext("webgpu")!;
//      _canvasContext = _canvas.getContext("webgpu")!;
        _presentationFormat = "rgba8unorm"; // navigator.gpu.getPreferredCanvasFormat();
//      _presentationFormat = "rgba8unorm"; // navigator.gpu.getPreferredCanvasFormat();
        _canvasContext.configure({ alphaMode: "opaque", colorSpace: "srgb", device: _device, format: _presentationFormat, toneMapping: { mode: "standard", }, usage: GPUTextureUsage.RENDER_ATTACHMENT, viewFormats: [ "rgba8unorm", ], });
//      _canvasContext.configure({ alphaMode: "opaque", colorSpace: "srgb", device: _device, format: _presentationFormat, toneMapping: { mode: "standard", }, usage: GPUTextureUsage.RENDER_ATTACHMENT, viewFormats: [ "rgba8unorm", ], });
        _backgroundShaderModule = _device.createShaderModule({
//      _backgroundShaderModule = _device.createShaderModule({
            label: "GPU_SHADER_MODULE_BACKGROUND",
//          label: "GPU_SHADER_MODULE_BACKGROUND",
            code: _backgroundShaderString,
//          code: _backgroundShaderString,
        });
//      });
        _backgroundBindGroupLayout0 = null;
//      _backgroundBindGroupLayout0 = null;
        _backgroundPipelineLayout = "auto";
//      _backgroundPipelineLayout = "auto";
        _backgroundPipeline = await _device.createRenderPipelineAsync({
//      _backgroundPipeline = await _device.createRenderPipelineAsync({
            label: "GPU_PIPELINE_BACKGROUND",
//          label: "GPU_PIPELINE_BACKGROUND",
            layout: _backgroundPipelineLayout,
//          layout: _backgroundPipelineLayout,
            vertex: {
//          vertex: {
                module: _backgroundShaderModule,
//              module: _backgroundShaderModule,
                entryPoint: "vs",
//              entryPoint: "vs",
            },
//          },
            fragment: {
//          fragment: {
                module: _backgroundShaderModule,
//              module: _backgroundShaderModule,
                entryPoint: "fs",
//              entryPoint: "fs",
                targets: [{ format: _presentationFormat }],
//              targets: [{ format: _presentationFormat }],
            },
//          },
        });
//      });
        _commandEncoderDescriptor = { label: "GPU_COMMAND_ENCODER_DESCRIPTOR", };
//      _commandEncoderDescriptor = { label: "GPU_COMMAND_ENCODER_DESCRIPTOR", };
        _backgroundPassDescriptor = {
//      _backgroundPassDescriptor = {
            label: "GPU_PASS_DESCRIPTOR_BACKGROUND",
//          label: "GPU_PASS_DESCRIPTOR_BACKGROUND",
            colorAttachments: [
//          colorAttachments: [
                {
                    view: undefined as any,
//                  view: undefined as any,
                    clearValue: [0.3, 0.3, 0.3, 1],
//                  clearValue: [0.3, 0.3, 0.3, 1],
                    loadOp: "clear",
//                  loadOp: "clear",
                    storeOp: "store",
//                  storeOp: "store",
                }
            ] as GPURenderPassColorAttachment[],
//          ] as GPURenderPassColorAttachment[],
        };
//      };
        _dataUniformValues = new Float32Array(4); // resolution is vec3<f32> | timeInSeconds is f32
//      _dataUniformValues = new Float32Array(4); // resolution is vec3<f32> | timeInSeconds is f32
        _dataUniformBuffer = _device.createBuffer({
//      _dataUniformBuffer = _device.createBuffer({
            label: "GPU_UNIFORM_BUFFER_DATA",
//          label: "GPU_UNIFORM_BUFFER_DATA",
            size: _dataUniformValues.byteLength,
//          size: _dataUniformValues.byteLength,
            usage: GPUBufferUsage.UNIFORM | GPUBufferUsage.COPY_DST,
//          usage: GPUBufferUsage.UNIFORM | GPUBufferUsage.COPY_DST,
        });
//      });
        _backgroundBindGroup0 = _device.createBindGroup({
//      _backgroundBindGroup0 = _device.createBindGroup({
            label: "GPU_BIND_GROUP_0_BACKGROUND",
//          label: "GPU_BIND_GROUP_0_BACKGROUND",
            layout: _backgroundPipeline.getBindGroupLayout(0),
//          layout: _backgroundPipeline.getBindGroupLayout(0),
            entries: [
//          entries: [
                {
//              {
                    binding: 0,
//                  binding: 0,
                    resource: _dataUniformBuffer,
//                  resource: _dataUniformBuffer,
                },
//              },
            ] as Iterable<GPUBindGroupEntry>,
//          ] as Iterable<GPUBindGroupEntry>,
        });
//      });
        _isRunningLoop = false;
//      _isRunningLoop = false;
        _frameHandleLoop = null!;
//      _frameHandleLoop = null!;
    };
//  };




    const loop = (time: number): void => {
//  const loop = (time: number): void => {
        _time = time;
//      _time = time;
        if (!_isRunningLoop) {
//      if (!_isRunningLoop) {
            return;
//          return;
        }
//      }
        prepare();
//      prepare();
        render();
//      render();
        _frameHandleLoop = requestAnimationFrame(loop);
//      _frameHandleLoop = requestAnimationFrame(loop);
    };
//  };
    const startLoop = (): void => {
//  const startLoop = (): void => {
        if (!_isRunningLoop) {
//      if (!_isRunningLoop) {
            _isRunningLoop = true;
//          _isRunningLoop = true;
            _frameHandleLoop = requestAnimationFrame(loop);
//          _frameHandleLoop = requestAnimationFrame(loop);
        }
//      }
    };
//  };
    const stopLoop = (): void => {
//  const stopLoop = (): void => {
        _isRunningLoop = false;
//      _isRunningLoop = false;
        if (_frameHandleLoop) {
//      if (_frameHandleLoop) {
            cancelAnimationFrame(_frameHandleLoop);
//          cancelAnimationFrame(_frameHandleLoop);
            _frameHandleLoop = null!;
//          _frameHandleLoop = null!;
        }
//      }
    };
//  };




    onMount(async (): Promise<void> => {
//  onMount(async (): Promise<void> => {
        await initOnce();
//      await initOnce();
        startLoop();
//      startLoop();
        /*
//      /*
        _resizeObserver = new ResizeObserver(
//      _resizeObserver = new ResizeObserver(
            (entries: ResizeObserverEntry[]) => {
//          (entries: ResizeObserverEntry[]) => {
                stopLoop();
//              stopLoop();
                for (const entry of entries) {
//              for (const entry of entries) {
                    const entryAsCanvas: HTMLCanvasElement = entry.target as HTMLCanvasElement;
//                  const entryAsCanvas: HTMLCanvasElement = entry.target as HTMLCanvasElement;
                    if (!entryAsCanvas) {
//                  if (!entryAsCanvas) {
                        return;
//                      return;
                    }
//                  }
                    const width : number = entry.contentBoxSize[0].inlineSize;
//                  const width : number = entry.contentBoxSize[0].inlineSize;
                    const height: number = entry.contentBoxSize[0]. blockSize;
//                  const height: number = entry.contentBoxSize[0]. blockSize;
                    entryAsCanvas.width  = Math.max(
//                  entryAsCanvas.width  = Math.max(
                        1,
//                      1,
                        Math.min(width, _device.limits.maxTextureDimension2D),
//                      Math.min(width, _device.limits.maxTextureDimension2D),
                    );
//                  );
                    entryAsCanvas.height = Math.max(
//                  entryAsCanvas.height = Math.max(
                        1,
//                      1,
                        Math.min(height, _device.limits.maxTextureDimension2D),
//                      Math.min(height, _device.limits.maxTextureDimension2D),
                    );
//                  );
                }
//              }
                startLoop();
//              startLoop();
            },
//          },
        );
//      );
        _resizeObserver.observe(_canvas);
//      _resizeObserver.observe(_canvas);
        */
//      */
    });
//  });




    onDestroy(async (): Promise<void> => {
//  onDestroy(async (): Promise<void> => {
        stopLoop();
//      stopLoop();
        if (_dataUniformBuffer) {
//      if (_dataUniformBuffer) {
            _dataUniformBuffer.destroy();
//          _dataUniformBuffer.destroy();
        }
//      }
        if (_device) {
//      if (_device) {
            _device.destroy();
//          _device.destroy();
        }
//      }
        /*
//      /*
        _resizeObserver.unobserve(_canvas);
//      _resizeObserver.unobserve(_canvas);
        _canvas = null!;
//      _canvas = null!;
        */
//      */
    });
//  });




    const render = (): void => {
//  const render = (): void => {
        (_backgroundPassDescriptor.colorAttachments as GPURenderPassColorAttachment[])[0].view = _canvasContext.getCurrentTexture();
//      (_backgroundPassDescriptor.colorAttachments as GPURenderPassColorAttachment[])[0].view = _canvasContext.getCurrentTexture();
        _commandEncoder = _device.createCommandEncoder(_commandEncoderDescriptor);
//      _commandEncoder = _device.createCommandEncoder(_commandEncoderDescriptor);


        _backgroundPass = _commandEncoder.beginRenderPass(_backgroundPassDescriptor);
//      _backgroundPass = _commandEncoder.beginRenderPass(_backgroundPassDescriptor);
        _backgroundPass.setPipeline(_backgroundPipeline);
//      _backgroundPass.setPipeline(_backgroundPipeline);
        _backgroundPass.setBindGroup(0, _backgroundBindGroup0);
//      _backgroundPass.setBindGroup(0, _backgroundBindGroup0);
        _backgroundPass.draw(6);
//      _backgroundPass.draw(6);
        _backgroundPass.end();
//      _backgroundPass.end();


        _commandBuffer = _commandEncoder.finish();
//      _commandBuffer = _commandEncoder.finish();
        _device.queue.submit([_commandBuffer]);
//      _device.queue.submit([_commandBuffer]);
    };
//  };



    const prepare = (): void => {
//  const prepare = (): void => {
        _dataUniformValues.set( // resolution is vec3<f32> | timeInSeconds is f32
//      _dataUniformValues.set( // resolution is vec3<f32> | timeInSeconds is f32
            [
//          [
                _canvas.width, _canvas.height, 0.0,
//              _canvas.width, _canvas.height, 0.0,
                _time / 1000.0,
//              _time / 1000.0,
            ],
//          ],
            0,
//          0,
        );
//      );
        _device.queue.writeBuffer(_dataUniformBuffer, 0, _dataUniformValues as GPUAllowSharedBufferSource);
//      _device.queue.writeBuffer(_dataUniformBuffer, 0, _dataUniformValues as GPUAllowSharedBufferSource);
    };
//  };




    const OnKeydown = async (keyboardEvent: KeyboardEvent): Promise<void> => {
//  const OnKeydown = async (keyboardEvent: KeyboardEvent): Promise<void> => {
    };
//  };




    </script>
<!--</script>-->

<!--<svelte:window on:keydown={OnKeydown} />-->
    <svelte:window on:keydown={OnKeydown} />
<!--<svelte:window on:keydown={OnKeydown} />-->

<!--<canvas style="position:fixed;z-index:-10;" bind:this={_canvas} width="960" height="540" style:width="960px" style:height="540px"></canvas>-->
    <canvas style="position:fixed;z-index:-10;" bind:this={_canvas} width="960" height="540" style:width="960px" style:height="540px"></canvas>
<!--<canvas style="position:fixed;z-index:-10;" bind:this={_canvas} width="960" height="540" style:width="960px" style:height="540px"></canvas>-->

<!--<svelte:options runes={true}></svelte:options>-->
    <svelte:options runes={true}></svelte:options>
<!--<svelte:options runes={true}></svelte:options>-->
