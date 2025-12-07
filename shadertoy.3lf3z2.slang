    struct VertexShaderInput {
//  struct VertexShaderInput {
        uint32_t vertexIndex: SV_VertexID;
//      uint32_t vertexIndex: SV_VertexID;
    };
//  };
    struct VertexShaderOutput {
//  struct VertexShaderOutput {
        float32_t4 vertexPosition: SV_Position;
//      float32_t4 vertexPosition: SV_Position;
    };
//  };
    struct FragmentShaderInput {
//  struct FragmentShaderInput {
        float32_t4 fragmentPosition: SV_Position;
//      float32_t4 fragmentPosition: SV_Position;
    };
//  };
    struct FragmentShaderOutput {
//  struct FragmentShaderOutput {
        float32_t4 fragmentColour: SV_Target0;
//      float32_t4 fragmentColour: SV_Target0;
    };
//  };
    struct GeneralData {
//  struct GeneralData {
        float32_t3 resolution;
//      float32_t3 resolution;
        float32_t timeInSeconds;
//      float32_t timeInSeconds;
    };
//  };
    static const constexpr float32_t4 vertexPosition[6] = {
//  static const constexpr float32_t4 vertexPosition[6] = {
        float32_t4(-1.0, -1.0,  0.0,  1.0),
//      float32_t4(-1.0, -1.0,  0.0,  1.0),
        float32_t4( 1.0, -1.0,  0.0,  1.0),
//      float32_t4( 1.0, -1.0,  0.0,  1.0),
        float32_t4(-1.0,  1.0,  0.0,  1.0),
//      float32_t4(-1.0,  1.0,  0.0,  1.0),
        float32_t4(-1.0,  1.0,  0.0,  1.0),
//      float32_t4(-1.0,  1.0,  0.0,  1.0),
        float32_t4( 1.0, -1.0,  0.0,  1.0),
//      float32_t4( 1.0, -1.0,  0.0,  1.0),
        float32_t4( 1.0,  1.0,  0.0,  1.0),
//      float32_t4( 1.0,  1.0,  0.0,  1.0),
    };
//  };
    ConstantBuffer<GeneralData> generalData;
//  ConstantBuffer<GeneralData> generalData;
    [shader("vertex")]
//  [shader("vertex")]
    VertexShaderOutput vs(VertexShaderInput vertexShaderInput) {
//  VertexShaderOutput vs(VertexShaderInput vertexShaderInput) {
        VertexShaderOutput vertexShaderOutput;
//      VertexShaderOutput vertexShaderOutput;
        vertexShaderOutput.vertexPosition = vertexPosition[vertexShaderInput.vertexIndex];
//      vertexShaderOutput.vertexPosition = vertexPosition[vertexShaderInput.vertexIndex];
        return vertexShaderOutput;
//      return vertexShaderOutput;
    };
//  };
    [shader("fragment")]
//  [shader("fragment")]
    FragmentShaderOutput fs(FragmentShaderInput fragmentShaderInput) {
//  FragmentShaderOutput fs(FragmentShaderInput fragmentShaderInput) {
        FragmentShaderOutput fragmentShaderOutput;
//      FragmentShaderOutput fragmentShaderOutput;
        fragmentShaderOutput.fragmentColour = float32_t4(0.0, 0.0, 0.0, 1.0);
//      fragmentShaderOutput.fragmentColour = float32_t4(0.0, 0.0, 0.0, 1.0);
        float32_t2 fragCoord = fragmentShaderInput.fragmentPosition.xy;
//      float32_t2 fragCoord = fragmentShaderInput.fragmentPosition.xy;
        fragCoord.y = generalData.resolution.y - fragCoord.y;
//      fragCoord.y = generalData.resolution.y - fragCoord.y;
        mainImage(fragmentShaderOutput.fragmentColour, fragCoord);
//      mainImage(fragmentShaderOutput.fragmentColour, fragCoord);
        return fragmentShaderOutput;
//      return fragmentShaderOutput;
    };
//  };
    float32_t hash(float32_t2 p) {
//  float32_t hash(float32_t2 p) {
        return fract(1e4 * sin(17.0 * p.x + p.y * 0.1) * (0.1 + abs(sin(p.y * 13.0 + p.x))));
//      return fract(1e4 * sin(17.0 * p.x + p.y * 0.1) * (0.1 + abs(sin(p.y * 13.0 + p.x))));
    };
//  };
    float32_t noise(float32_t2 x) {
//  float32_t noise(float32_t2 x) {
        float32_t2 i = floor(x);
//      float32_t2 i = floor(x);
        float32_t2 f = fract(x);
//      float32_t2 f = fract(x);
        float32_t a = hash(i);
//      float32_t a = hash(i);
        float32_t b = hash(i + float32_t2(1.0, 0.0));
//      float32_t b = hash(i + float32_t2(1.0, 0.0));
        float32_t c = hash(i + float32_t2(0.0, 1.0));
//      float32_t c = hash(i + float32_t2(0.0, 1.0));
        float32_t d = hash(i + float32_t2(1.0, 1.0));
//      float32_t d = hash(i + float32_t2(1.0, 1.0));
        float32_t2 u = f * f * (3.0 - 2.0 * f);
//      float32_t2 u = f * f * (3.0 - 2.0 * f);
        return lerp(a, b, u.x) + (c - a) * u.y * (1.0 - u.x) + (d - b) * u.x * u.y;
//      return lerp(a, b, u.x) + (c - a) * u.y * (1.0 - u.x) + (d - b) * u.x * u.y;
    };
//  };
    #define octaves 14
//  #define octaves 14
    float32_t fbm (in float32_t2 p) {
//  float32_t fbm (in float32_t2 p) {
        float32_t value = 0.0;
//      float32_t value = 0.0;
        float32_t freq = 1.0;
//      float32_t freq = 1.0;
        float32_t amp = 0.5;
//      float32_t amp = 0.5;
        for (int i = 0; i < octaves; i++) {
//      for (int i = 0; i < octaves; i++) {
            value += amp * (noise((p - float32_t2(1.0)) * freq));
//          value += amp * (noise((p - float32_t2(1.0)) * freq));
            freq *= 1.9;
//          freq *= 1.9;
            amp *= 0.6;
//          amp *= 0.6;
        }
//      }
        return value;
//      return value;
    };
//  };
    float32_t pattern(in float32_t2 p) {
//  float32_t pattern(in float32_t2 p) {
        float32_t2 offset = float32_t2(-0.5);
//      float32_t2 offset = float32_t2(-0.5);
        float32_t2 aPos = float32_t2(sin(generalData.timeInSeconds * 0.005), sin(generalData.timeInSeconds * 0.01)) * 6.0;
//      float32_t2 aPos = float32_t2(sin(generalData.timeInSeconds * 0.005), sin(generalData.timeInSeconds * 0.01)) * 6.0;
        float32_t2 aScale = float32_t2(3.0);
//      float32_t2 aScale = float32_t2(3.0);
        float32_t a = fbm(p * aScale + aPos);
//      float32_t a = fbm(p * aScale + aPos);
        float32_t2 bPos = float32_t2(sin(generalData.timeInSeconds * 0.010), sin(generalData.timeInSeconds * 0.01)) * 1.0;
//      float32_t2 bPos = float32_t2(sin(generalData.timeInSeconds * 0.010), sin(generalData.timeInSeconds * 0.01)) * 1.0;
        float32_t2 bScale = float32_t2(0.6);
//      float32_t2 bScale = float32_t2(0.6);
        float32_t b = fbm((p + a) * bScale + bPos);
//      float32_t b = fbm((p + a) * bScale + bPos);
        float32_t2 cPos = float32_t2(-0.6, -0.5) + float32_t2(sin(-generalData.timeInSeconds * 0.001), sin(generalData.timeInSeconds * 0.01)) * 2.0;
//      float32_t2 cPos = float32_t2(-0.6, -0.5) + float32_t2(sin(-generalData.timeInSeconds * 0.001), sin(generalData.timeInSeconds * 0.01)) * 2.0;
        float32_t2 cScale = float32_t2(2.6);
//      float32_t2 cScale = float32_t2(2.6);
        float32_t c = fbm((p + b) * cScale + cPos);
//      float32_t c = fbm((p + b) * cScale + cPos);
        return c;
//      return c;
    };
//  };
    float32_t3 palette(in float32_t t) {
//  float32_t3 palette(in float32_t t) {
        float32_t3 a = float32_t3(0.50, 0.50, 0.50);
//      float32_t3 a = float32_t3(0.50, 0.50, 0.50);
        float32_t3 b = float32_t3(0.45, 0.25, 0.14);
//      float32_t3 b = float32_t3(0.45, 0.25, 0.14);
        float32_t3 c = float32_t3(1.00, 1.00, 1.00);
//      float32_t3 c = float32_t3(1.00, 1.00, 1.00);
        float32_t3 d = float32_t3(0.00, 0.10, 0.20);
//      float32_t3 d = float32_t3(0.00, 0.10, 0.20);
        return a + b * cos(6.28318 * (c * t + d));
//      return a + b * cos(6.28318 * (c * t + d));
    };
//  };
    void mainImage(out float32_t4 fragColor, in float32_t2 fragCoord) {
//  void mainImage(out float32_t4 fragColor, in float32_t2 fragCoord) {
        float32_t2 p = fragCoord.xy / generalData.resolution.xy;
//      float32_t2 p = fragCoord.xy / generalData.resolution.xy;
        p.x *= generalData.resolution.x / generalData.resolution.y;
//      p.x *= generalData.resolution.x / generalData.resolution.y;
        float32_t value = pow(pattern(p), 2.0); // more "islands"
//      float32_t value = pow(pattern(p), 2.0); // more "islands"
        float32_t3 color = palette(value);
//      float32_t3 color = palette(value);
        fragColor = float32_t4(color, 1.0);
//      fragColor = float32_t4(color, 1.0);
    };
//  };
