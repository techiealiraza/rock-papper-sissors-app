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

      },
      spacing: {
        '40': '40%',
        '50': '50%',
        '20': '20%',
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