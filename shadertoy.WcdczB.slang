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
        float32_t2 resolution;
//      float32_t2 resolution;
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
        float32_t timeInSeconds = generalData.timeInSeconds;
//      float32_t timeInSeconds = generalData.timeInSeconds;
        FragmentShaderOutput fragmentShaderOutput;
//      FragmentShaderOutput fragmentShaderOutput;
        fragmentShaderOutput.fragmentColour = float32_t4(timeInSeconds, 0.0, 0.0, 1.0);
//      fragmentShaderOutput.fragmentColour = float32_t4(timeInSeconds, 0.0, 0.0, 1.0);
        return fragmentShaderOutput;
//      return fragmentShaderOutput;
    };
//  };
