import type { Config } from "tailwindcss";

const config: Config = {
  content: [
    "./pages/**/*.{js,ts,jsx,tsx,mdx}",
    "./components/**/*.{js,ts,jsx,tsx,mdx}",
    "./app/**/*.{js,ts,jsx,tsx,mdx}",
  ],
  theme: {
    extend: {
      colors: {
        // Brand colors from logo
        brand: {
          blue: "#4A9FD8",
          purple: "#8B5CF6",
          orange: "#FF8A3D",
          red: "#EF4444",
          pink: "#E91E63",
        },
      },
      backgroundImage: {
        "gradient-blue-purple": "linear-gradient(135deg, #4A9FD8 0%, #8B5CF6 100%)",
        "gradient-orange-red": "linear-gradient(135deg, #FF8A3D 0%, #EF4444 100%)",
      },
    },
  },
  plugins: [],
};

export default config;
