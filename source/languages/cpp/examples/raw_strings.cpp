int main()
{
    auto const vertexShader
    {R"glsl(
        precision highp float;
        attribute vec2 vPosition;
        attribute vec3 textureCoord;
        varying   vec3 tCoord;

        void main()
        {
            gl_Position = vec4( vPosition, 0.0, 1.0 );
            tCoord      = textureCoord;
        }
    )glsl"};

    auto const sqlQuery
    {R"sql(
        select a, b, c from someTable where a > 10 order by a asc
    )sql"};

    auto const regexExpression
    {R"re(
        ((?:[uUL]8?)?R)\\\"(?:(?:_r|re)|regex)\\()
    )re"};

    return 0;
}
