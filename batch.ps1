slangc.exe "shadertoy.3lf3z2.slang" -target wgsl -o "shadertoy.3lf3z2.wgsl" -entry vs -entry fs ;
slangc.exe "shadertoy.Ms2SD1.slang" -target wgsl -o "shadertoy.Ms2SD1.wgsl" -entry vs -entry fs ;
slangc.exe "shadertoy.WcdczB.slang" -target wgsl -o "shadertoy.WcdczB.wgsl" -entry vs -entry fs ;
copy .\shadertoy.3lf3z2.wgsl .\webgpu\static\ ;
copy .\shadertoy.Ms2SD1.wgsl .\webgpu\static\ ;
copy .\shadertoy.WcdczB.wgsl .\webgpu\static\ ;
