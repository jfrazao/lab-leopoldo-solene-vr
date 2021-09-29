#version 400
uniform vec2 scale = vec2(1, 1);
uniform vec4 color = vec4(0,0,0,1);
uniform vec4 backColor = vec4(1);
uniform float radius = 1;
in vec2 texCoord;
out vec4 fragColor;

void main()
{
  float dist =length((2 * mod(texCoord*scale,1) - 1));
  fragColor = (dist > radius)?backColor: color;
}