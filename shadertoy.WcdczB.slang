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
        float32_t T = generalData.timeInSeconds * 4.0 + 5.0 + 5.0 * sin(generalData.timeInSeconds * 0.3);
//      float32_t T = generalData.timeInSeconds * 4.0 + 5.0 + 5.0 * sin(generalData.timeInSeconds * 0.3);
        float32_t t = 0.0;
//      float32_t t = 0.0;
        float32_t s = 0.0;
//      float32_t s = 0.0;
        float32_t i = 0.0;
//      float32_t i = 0.0;
        float32_t d = 0.0;
//      float32_t d = 0.0;
        float32_t e = 0.0;
//      float32_t e = 0.0;
        float32_t3 c = float32_t3(0.0);
//      float32_t3 c = float32_t3(0.0);
        float32_t3 r = generalData.resolution;
//      float32_t3 r = generalData.resolution;
        float32_t2 u = (fragmentShaderInput.fragmentPosition.xy - r.xy / 2.0) / r.y;
//      float32_t2 u = (fragmentShaderInput.fragmentPosition.xy - r.xy / 2.0) / r.y;
        if (abs(u.y) > 0.375) {
//      if (abs(u.y) > 0.375) {
            return fragmentShaderOutput;
//          return fragmentShaderOutput;
        }
//      }
        float32_t3 p = P(T);
//      float32_t3 p = P(T);
        float32_t3 Z = normalize(P(T + 4.0) - p);
//      float32_t3 Z = normalize(P(T + 4.0) - p);
        float32_t3 X = normalize(float32_t3(Z.z, 0.0, -Z.x));
//      float32_t3 X = normalize(float32_t3(Z.z, 0.0, -Z.x));
        float32_t3 D = u.x * (-X) + u.y * cross(X, Z) + 1.0 * Z;
//      float32_t3 D = u.x * (-X) + u.y * cross(X, Z) + 1.0 * Z;
        for(; i++ < 28.0 && d < 3e1; c += 1.0 / s + 1e1 * float32_t3(1.0, 2.0, 5.0) / max(e, 0.6)) {
//      for(; i++ < 28.0 && d < 3e1; c += 1.0 / s + 1e1 * float32_t3(1.0, 2.0, 5.0) / max(e, 0.6)) {
            p += D * s;
//          p += D * s;
            X = P(p.z);
//          X = P(p.z);
            t = sin(generalData.timeInSeconds);
//          t = sin(generalData.timeInSeconds);
            e = length(p -
//          e = length(p -
                float32_t3(
//              float32_t3(
                    X.x     + t      ,
//                  X.x     + t      ,
                    X.y     + t * 2.0,
//                  X.y     + t * 2.0,
                    6.0 + T + t * 2.0
//                  6.0 + T + t * 2.0
                )
//              )
            ) - 0.01;
//          ) - 0.01;
            s = cos(p.z * 0.6) * 2.0 + 4.0
//          s = cos(p.z * 0.6) * 2.0 + 4.0
                - min(length(p.xy - X.x - 6.0), length((p - X).xy))
//              - min(length(p.xy - X.x - 6.0), length((p - X).xy))
                + A(    4.0, 0.25, 0.1, p)
//              + A(    4.0, 0.25, 0.1, p)
                + A(T + 8.0, 0.22, 2.0, p);
//              + A(T + 8.0, 0.22, 2.0, p);
            d += s = min(e, 0.01 + 0.3 * abs(s));
//          d += s = min(e, 0.01 + 0.3 * abs(s));
        }
//      }
        fragmentShaderOutput.fragmentColour.rgb = c * c / 1e6;
//      fragmentShaderOutput.fragmentColour.rgb = c * c / 1e6;
        return fragmentShaderOutput;
//      return fragmentShaderOutput;
    };
//  };
    float32_t3 P(float32_t z) {
//  float32_t3 P(float32_t z) {
        return float32_t3(12.0 * cos(z * float32_t2(0.1, 0.12)), z);
//      return float32_t3(12.0 * cos(z * float32_t2(0.1, 0.12)), z);
    };
//  };
    float32_t A(float32_t F, float32_t H, float32_t K, float32_t3 p) {
//  float32_t A(float32_t F, float32_t H, float32_t K, float32_t3 p) {
        return abs(dot(sin(F * p * K), H + p - p)) / K;
//      return abs(dot(sin(F * p * K), H + p - p)) / K;
    };
//  };
