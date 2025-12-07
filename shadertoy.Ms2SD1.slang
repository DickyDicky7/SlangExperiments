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
    static const constexpr float32_t4 iMouse = float32_t4(0.0, 0.0, 0.0, 0.0);
//  static const constexpr float32_t4 iMouse = float32_t4(0.0, 0.0, 0.0, 0.0);

    /*
//  /*
     * "Seascape" by Alexander Alekseev aka TDM - 2014
//   * "Seascape" by Alexander Alekseev aka TDM - 2014
     * License Creative Commons Attribution-NonCommercial-ShareAlike 3.0 Unported License.
//   * License Creative Commons Attribution-NonCommercial-ShareAlike 3.0 Unported License.
     * Contact: tdmaav@gmail.com
//   * Contact: tdmaav@gmail.com
     */
//   */
    static const constexpr int32_t NUM_STEPS = 32;
//  static const constexpr int32_t NUM_STEPS = 32;
    static const constexpr float32_t PI = 3.141592;
//  static const constexpr float32_t PI = 3.141592;
    static const constexpr float32_t EPSILON = 1e-3;
//  static const constexpr float32_t EPSILON = 1e-3;
    #define EPSILON_NRM (0.1 / generalData.resolution.x)
//  #define EPSILON_NRM (0.1 / generalData.resolution.x)
    #define AA
//  #define AA
    // sea
//  // sea
    static const constexpr int32_t ITER_GEOMETRY = 3;
//  static const constexpr int32_t ITER_GEOMETRY = 3;
    static const constexpr int32_t ITER_FRAGMENT = 5;
//  static const constexpr int32_t ITER_FRAGMENT = 5;
    static const constexpr float32_t SEA_HEIGHT = 0.6;
//  static const constexpr float32_t SEA_HEIGHT = 0.6;
    static const constexpr float32_t SEA_CHOPPY = 4.0;
//  static const constexpr float32_t SEA_CHOPPY = 4.0;
    static const constexpr float32_t SEA_SPEED = 0.8;
//  static const constexpr float32_t SEA_SPEED = 0.8;
    static const constexpr float32_t SEA_FREQ = 0.16;
//  static const constexpr float32_t SEA_FREQ = 0.16;
    static const constexpr float32_t3 SEA_BASE = float32_t3(0.0, 0.09, 0.18);
//  static const constexpr float32_t3 SEA_BASE = float32_t3(0.0, 0.09, 0.18);
    static const constexpr float32_t3 SEA_WATER_COLOR = float32_t3(0.8, 0.9, 0.6) * 0.6;
//  static const constexpr float32_t3 SEA_WATER_COLOR = float32_t3(0.8, 0.9, 0.6) * 0.6;
    #define SEA_TIME (1.0 + generalData.timeInSeconds * SEA_SPEED)
//  #define SEA_TIME (1.0 + generalData.timeInSeconds * SEA_SPEED)
    static const constexpr float32_t2x2 octave_m = float32_t2x2(1.6, -1.2, 1.2, 1.6);
//  static const constexpr float32_t2x2 octave_m = float32_t2x2(1.6,  1.2, -1.2, 1.6);
    // math
//  // math
    float32_t3x3 fromEuler(float32_t3 ang) {
//  float32_t3x3 fromEuler(float32_t3 ang) {
        float32_t2 a1 = float32_t2(sin(ang.x), cos(ang.x));
//      float32_t2 a1 = float32_t2(sin(ang.x), cos(ang.x));
        float32_t2 a2 = float32_t2(sin(ang.y), cos(ang.y));
//      float32_t2 a2 = float32_t2(sin(ang.y), cos(ang.y));
        float32_t2 a3 = float32_t2(sin(ang.z), cos(ang.z));
//      float32_t2 a3 = float32_t2(sin(ang.z), cos(ang.z));
        float32_t3x3 m;
//      float32_t3x3 m;
        m[0] = float32_t3( a1.y * a3.y + a1.x * a2.x * a3.x, a1.y * a2.x * a3.x + a3.y * a1.x, -a2.y * a3.x);
//      m[0] = float32_t3( a1.y * a3.y + a1.x * a2.x * a3.x, a1.y * a2.x * a3.x + a3.y * a1.x, -a2.y * a3.x);
        m[1] = float32_t3(-a2.y * a1.x                     , a1.y * a2.y                     ,  a2.x       );
//      m[1] = float32_t3(-a2.y * a1.x                     , a1.y * a2.y                     ,  a2.x       );
        m[2] = float32_t3( a3.y * a1.x * a2.x + a1.y * a3.x, a1.x * a3.x - a1.y * a3.y * a2.x,  a2.y * a3.y);
//      m[2] = float32_t3( a3.y * a1.x * a2.x + a1.y * a3.x, a1.x * a3.x - a1.y * a3.y * a2.x,  a2.y * a3.y);
        return m;
//      return m;
    };
//  };
    float32_t hash(float32_t2 p) {
//  float32_t hash(float32_t2 p) {
        float32_t h = dot(p, float32_t2(127.1, 311.7));
//      float32_t h = dot(p, float32_t2(127.1, 311.7));
        return fract(sin(h) * 43758.5453123);
//      return fract(sin(h) * 43758.5453123);
    };
//  };
    float32_t noise(in float32_t2 p) {
//  float32_t noise(in float32_t2 p) {
        float32_t2 i = floor(p);
//      float32_t2 i = floor(p);
        float32_t2 f = fract(p);
//      float32_t2 f = fract(p);
        float32_t2 u = f * f * (3.0 - 2.0 * f);
//      float32_t2 u = f * f * (3.0 - 2.0 * f);
        return -1.0
//      return -1.0
             +  2.0
//           +  2.0
             *  lerp(
//           *  lerp(
                    lerp(hash(i + float32_t2(0.0, 0.0)), hash(i + float32_t2(1.0, 0.0)), u.x),
//                  lerp(hash(i + float32_t2(0.0, 0.0)), hash(i + float32_t2(1.0, 0.0)), u.x),
                    lerp(hash(i + float32_t2(0.0, 1.0)), hash(i + float32_t2(1.0, 1.0)), u.x),
//                  lerp(hash(i + float32_t2(0.0, 1.0)), hash(i + float32_t2(1.0, 1.0)), u.x),
                    u.y
//                  u.y
                );
//              );
    };
//  };
    // lighting
//  // lighting
    float32_t diffuse(float32_t3 n, float32_t3 l, float32_t p) {
//  float32_t diffuse(float32_t3 n, float32_t3 l, float32_t p) {
        return pow(dot(n, l) * 0.4 + 0.6, p);
//      return pow(dot(n, l) * 0.4 + 0.6, p);
    };
//  };
    float32_t specular(float32_t3 n, float32_t3 l, float32_t3 e, float32_t s) {
//  float32_t specular(float32_t3 n, float32_t3 l, float32_t3 e, float32_t s) {
        float32_t nrm = (s + 8.0) / (PI * 8.0);
//      float32_t nrm = (s + 8.0) / (PI * 8.0);
        return pow(max(dot(reflect(e, n), l), 0.0), s) * nrm;
//      return pow(max(dot(reflect(e, n), l), 0.0), s) * nrm;
    };
//  };
    // sky
//  // sky
    float32_t3 getSkyColor(float32_t3 e) {
//  float32_t3 getSkyColor(float32_t3 e) {
        e.y = (max(e.y, 0.0) * 0.8 + 0.2) * 0.8;
//      e.y = (max(e.y, 0.0) * 0.8 + 0.2) * 0.8;
        return float32_t3(pow(1.0 - e.y, 2.0), 1.0 - e.y, 0.6 + (1.0 - e.y) * 0.4) * 1.1;
//      return float32_t3(pow(1.0 - e.y, 2.0), 1.0 - e.y, 0.6 + (1.0 - e.y) * 0.4) * 1.1;
    };
//  };
    // sea
//  // sea
    float32_t sea_octave(float32_t2 uv, float32_t choppy) {
//  float32_t sea_octave(float32_t2 uv, float32_t choppy) {
        uv += noise(uv);
//      uv += noise(uv);
        float32_t2 wv  = 1.0 - abs(sin(uv));
//      float32_t2 wv  = 1.0 - abs(sin(uv));
        float32_t2 swv =       abs(cos(uv));
//      float32_t2 swv =       abs(cos(uv));
        wv = lerp(wv, swv, wv);
//      wv = lerp(wv, swv, wv);
        return pow(1.0 - pow(wv.x * wv.y, 0.65), choppy);
//      return pow(1.0 - pow(wv.x * wv.y, 0.65), choppy);
    };
//  };
    float32_t map(float32_t3 p) {
//  float32_t map(float32_t3 p) {
        float32_t freq = SEA_FREQ;
//      float32_t freq = SEA_FREQ;
        float32_t amp = SEA_HEIGHT;
//      float32_t amp = SEA_HEIGHT;
        float32_t choppy = SEA_CHOPPY;
//      float32_t choppy = SEA_CHOPPY;
        float32_t2 uv = p.xz; uv.x *= 0.75;
//      float32_t2 uv = p.xz; uv.x *= 0.75;
        float32_t d, h = 0.0;
//      float32_t d, h = 0.0;
        for (int i = 0; i < ITER_GEOMETRY; i++) {
//      for (int i = 0; i < ITER_GEOMETRY; i++) {
            d  = sea_octave((uv + SEA_TIME) * freq, choppy);
//          d  = sea_octave((uv + SEA_TIME) * freq, choppy);
            d += sea_octave((uv - SEA_TIME) * freq, choppy);
//          d += sea_octave((uv - SEA_TIME) * freq, choppy);
            h += d * amp;
//          h += d * amp;
            uv = mul(uv, octave_m); freq *= 1.9; amp *= 0.22;
//          uv = mul(uv, octave_m); freq *= 1.9; amp *= 0.22;
            choppy = lerp(choppy, 1.0, 0.2);
//          choppy = lerp(choppy, 1.0, 0.2);
        }
//      }
        return p.y - h;
//      return p.y - h;
    };
//  };
    float32_t map_detailed(float32_t3 p) {
//  float32_t map_detailed(float32_t3 p) {
        float32_t freq = SEA_FREQ;
//      float32_t freq = SEA_FREQ;
        float32_t amp = SEA_HEIGHT;
//      float32_t amp = SEA_HEIGHT;
        float32_t choppy = SEA_CHOPPY;
//      float32_t choppy = SEA_CHOPPY;
        float32_t2 uv = p.xz; uv.x *= 0.75;
//      float32_t2 uv = p.xz; uv.x *= 0.75;
        float32_t d, h = 0.0;
//      float32_t d, h = 0.0;
        for (int i = 0; i < ITER_FRAGMENT; i++) {
//      for (int i = 0; i < ITER_FRAGMENT; i++) {
            d  = sea_octave((uv + SEA_TIME) * freq, choppy);
//          d  = sea_octave((uv + SEA_TIME) * freq, choppy);
            d += sea_octave((uv - SEA_TIME) * freq, choppy);
//          d += sea_octave((uv - SEA_TIME) * freq, choppy);
            h += d * amp;
//          h += d * amp;
            uv = mul(uv, octave_m); freq *= 1.9; amp *= 0.22;
//          uv = mul(uv, octave_m); freq *= 1.9; amp *= 0.22;
            choppy = lerp(choppy, 1.0, 0.2);
//          choppy = lerp(choppy, 1.0, 0.2);
        }
//      }
        return p.y - h;
//      return p.y - h;
    };
//  };
    float32_t3 getSeaColor(float32_t3 p, float32_t3 n, float32_t3 l, float32_t3 eye, float32_t3 dist) {
//  float32_t3 getSeaColor(float32_t3 p, float32_t3 n, float32_t3 l, float32_t3 eye, float32_t3 dist) {
        float32_t fresnel = clamp(1.0 - dot(n, -eye), 0.0, 1.0);
//      float32_t fresnel = clamp(1.0 - dot(n, -eye), 0.0, 1.0);
        fresnel = min(fresnel * fresnel * fresnel, 0.5);
//      fresnel = min(fresnel * fresnel * fresnel, 0.5);
        float32_t3 reflected = getSkyColor(reflect(eye, n));
//      float32_t3 reflected = getSkyColor(reflect(eye, n));
        float32_t3 refracted = SEA_BASE + diffuse(n, l, 80.0) * SEA_WATER_COLOR * 0.12;
//      float32_t3 refracted = SEA_BASE + diffuse(n, l, 80.0) * SEA_WATER_COLOR * 0.12;
        float32_t3 color = lerp(refracted, reflected, fresnel);
//      float32_t3 color = lerp(refracted, reflected, fresnel);
        float32_t atten = max(1.0 - dot(dist, dist) * 0.001, 0.0);
//      float32_t atten = max(1.0 - dot(dist, dist) * 0.001, 0.0);
        color += SEA_WATER_COLOR * (p.y - SEA_HEIGHT) * 0.18 * atten;
//      color += SEA_WATER_COLOR * (p.y - SEA_HEIGHT) * 0.18 * atten;
        color += specular(n, l, eye, 600.0 * rsqrt(dot(dist, dist)));
//      color += specular(n, l, eye, 600.0 * rsqrt(dot(dist, dist)));
        return color;
//      return color;
    };
//  };
    // tracing
//  // tracing
    float32_t3 getNormal(float32_t3 p, float32_t eps) {
//  float32_t3 getNormal(float32_t3 p, float32_t eps) {
        float32_t3 n;
//      float32_t3 n;
        n.y = map_detailed(p);
//      n.y = map_detailed(p);
        n.x = map_detailed(float32_t3(p.x + eps, p.y, p.z      )) - n.y;
//      n.x = map_detailed(float32_t3(p.x + eps, p.y, p.z      )) - n.y;
        n.z = map_detailed(float32_t3(p.x      , p.y, p.z + eps)) - n.y;
//      n.z = map_detailed(float32_t3(p.x      , p.y, p.z + eps)) - n.y;
        n.y = eps;
//      n.y = eps;
        return normalize(n);
//      return normalize(n);
    };
//  };
    float32_t heightMapTracing(float32_t3 ori, float32_t3 dir, out float32_t3 p) {
//  float32_t heightMapTracing(float32_t3 ori, float32_t3 dir, out float32_t3 p) {
        float32_t tm = 0.0;
//      float32_t tm = 0.0;
        float32_t tx = 1000.0;
//      float32_t tx = 1000.0;
        float32_t hx = map(ori + dir * tx);
//      float32_t hx = map(ori + dir * tx);
        if (hx > 0.0) {
//      if (hx > 0.0) {
            p = ori + dir * tx;
//          p = ori + dir * tx;
            return tx;
//          return tx;
        }
//      }
        float32_t hm = map(ori);
//      float32_t hm = map(ori);
        for (int i = 0; i < NUM_STEPS; i++) {
//      for (int i = 0; i < NUM_STEPS; i++) {
            float32_t tmid = lerp(tm, tx, hm / (hm - hx));
//          float32_t tmid = lerp(tm, tx, hm / (hm - hx));
            p = ori + dir * tmid;
//          p = ori + dir * tmid;
            float32_t hmid = map(p);
//          float32_t hmid = map(p);
            if (hmid < 0.0) {
//          if (hmid < 0.0) {
                tx = tmid;
//              tx = tmid;
                hx = hmid;
//              hx = hmid;
            } else {
//          } else {
                tm = tmid;
//              tm = tmid;
                hm = hmid;
//              hm = hmid;
            }
//          }
            if (abs(hmid) < EPSILON) {
//          if (abs(hmid) < EPSILON) {
                break;
//              break;
            }
//          }
        }
//      }
        return lerp(tm, tx, hm / (hm - hx));
//      return lerp(tm, tx, hm / (hm - hx));
    };
//  };
    float32_t3 getPixel(in float32_t2 coord, float32_t time) {
//  float32_t3 getPixel(in float32_t2 coord, float32_t time) {
        float32_t2 uv = coord / generalData.resolution.xy;
//      float32_t2 uv = coord / generalData.resolution.xy;
        uv = uv * 2.0 - 1.0;
//      uv = uv * 2.0 - 1.0;
        uv.x *= generalData.resolution.x / generalData.resolution.y;
//      uv.x *= generalData.resolution.x / generalData.resolution.y;
        // ray
//      // ray
        float32_t3 ang = float32_t3(sin(time * 3.0) * 0.1, sin(time) * 0.2 + 0.3, time);
//      float32_t3 ang = float32_t3(sin(time * 3.0) * 0.1, sin(time) * 0.2 + 0.3, time);
        float32_t3 ori = float32_t3(0.0, 3.5, time * 5.0);
//      float32_t3 ori = float32_t3(0.0, 3.5, time * 5.0);
        float32_t3 dir = normalize(float32_t3(uv.xy, -2.0)); dir.z += length(uv) * 0.14;
//      float32_t3 dir = normalize(float32_t3(uv.xy, -2.0)); dir.z += length(uv) * 0.14;
        dir = mul(normalize(dir), fromEuler(ang));
//      dir = mul(normalize(dir), fromEuler(ang));
        // tracing
//      // tracing
        float32_t3 p;
//      float32_t3 p;
        heightMapTracing(ori, dir, p);
//      heightMapTracing(ori, dir, p);
        float32_t3 dist = p - ori;
//      float32_t3 dist = p - ori;
        float32_t3 n = getNormal(p, dot(dist, dist) * EPSILON_NRM);
//      float32_t3 n = getNormal(p, dot(dist, dist) * EPSILON_NRM);
        float32_t3 light = normalize(float32_t3(0.0, 1.0, 0.8));
//      float32_t3 light = normalize(float32_t3(0.0, 1.0, 0.8));
        // color
//      // color
        return lerp(
//      return lerp(
            getSkyColor(dir),
//          getSkyColor(dir),
            getSeaColor(p, n, light, dir, dist),
//          getSeaColor(p, n, light, dir, dist),
            pow(smoothstep(0.0, -0.02, dir.y), 0.2)
//          pow(smoothstep(0.0, -0.02, dir.y), 0.2)
        );
//      );
    };
//  };
    // main
//  // main
    void mainImage(out float32_t4 fragColor, in float32_t2 fragCoord) {
//  void mainImage(out float32_t4 fragColor, in float32_t2 fragCoord) {
        float time = generalData.timeInSeconds * 0.3 + iMouse.x * 0.01;
//      float time = generalData.timeInSeconds * 0.3 + iMouse.x * 0.01;
    #ifdef AA
//  #ifdef AA
        float32_t3 color = float32_t3(0.0);
//      float32_t3 color = float32_t3(0.0);
        for (int i = -1; i <= 1; i++) {
//      for (int i = -1; i <= 1; i++) {
            for (int j = -1; j <= 1; j++) {
//          for (int j = -1; j <= 1; j++) {
                float32_t2 uv = fragCoord + float32_t2(i, j) / 3.0;
//              float32_t2 uv = fragCoord + float32_t2(i, j) / 3.0;
                color += getPixel(uv, time);
//              color += getPixel(uv, time);
            }
//          }
        }
//      }
        color /= 9.0;
//      color /= 9.0;
    #else
//  #else
        float32_t3 color = getPixel(fragCoord, time);
//      float32_t3 color = getPixel(fragCoord, time);
    #endif
//  #endif
        // post
//      // post
        fragColor = float32_t4(pow(color, float32_t3(0.65)), 1.0);
//      fragColor = float32_t4(pow(color, float32_t3(0.65)), 1.0);
    };
//  };
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
