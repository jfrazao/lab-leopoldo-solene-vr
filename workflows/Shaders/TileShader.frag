#version 400
uniform vec2 frequency = vec2(1, 1);
uniform vec4 color = vec4(0,0,0,1);
uniform vec4 backColor = vec4(1);
uniform float radius = 1;
in vec2 texCoord;
out vec4 fragColor;

void main()
{
  float bitH = uint(texCoord.x * frequency.x ) % 2;
  float bitV = uint(texCoord.y * frequency.y) % 2;
  bitH = bitV != 0 ? uint(bitH + 1) % 2 : bitH;
  vec4 finalColor = bitH != 0 ? color : backColor;
  fragColor = vec4(finalColor);
}