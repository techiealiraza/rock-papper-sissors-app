const defaultTheme = require('tailwindcss/defaultTheme')

module.exports = {
  content: [
    './public/*.html',
    './app/helpers/**/*.rb',
    './app/javascript/**/*.js',
    './app/views/**/*.{erb,haml,html,slim}'
  ],
  theme: {
    extend: {
      screens: {
        'mini': '200px',
        'md': '768px',
        'lg': '1024px',
      },
      backgroundImage: {
        'background-image': "url('background1.jpeg')",
        'default_avatar': "url('default_avatar.png')",
        'default_image': "url('image_icon.png')",
        'camera_icon': "url('camera.png')",
        'rock_icon': "url('rock.png')",
        'scissor_icon': "url('scissor.png')",
        'paper_icon': "url('paper.png')",
        'question_icon': "url('question.png')",
        'victory': "url('victory.png')",
        'defeat': "url('defeat.png')",
        '404': "url('404.png')",

      },
      colors: {
        "gold": "#d97706",
        "gold_shade2": "#b45309",
      },

      fontFamily: {
        sans: ['Inter var', ...defaultTheme.fontFamily.sans],
      },
    },
  },
  plugins: [
    require('@tailwindcss/forms'),
    require('@tailwindcss/aspect-ratio'),
    require('@tailwindcss/typography'),
    require('@tailwindcss/line-clamp'),
    require('@tailwindcss/container-queries'),
  ]
}