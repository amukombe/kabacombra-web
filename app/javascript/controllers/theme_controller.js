import { Controller } from "@hotwired/stimulus"

// Connects to data-controller="theme"
export default class extends Controller {
  connect() {
    //this.displayTheme();
    // On page load or when changing themes, best to add inline in `head` to avoid FOUC
    var themeToggleDarkIcon1 = document.getElementById('theme-toggle-dark-icon');
    var themeToggleLightIcon1 = document.getElementById('theme-toggle-light-icon');
    if (localStorage.getItem('color-theme') === 'dark' || (!('color-theme' in localStorage) && window.matchMedia('(prefers-color-scheme: dark)').matches)) {
        document.documentElement.classList.add('dark');
        themeToggleLightIcon1.classList.remove('hidden');
    } else {
        document.documentElement.classList.remove('dark');
        themeToggleDarkIcon1.classList.remove('hidden');
    }
  }

  async displayTheme(){
    var themeToggleDarkIcon = document.getElementById('theme-toggle-dark-icon');
    var themeToggleLightIcon = document.getElementById('theme-toggle-light-icon');
    
    // Check for saved theme preference in localStorage
    const currentTheme = localStorage.getItem('color-theme');
    const isSystemDark = window.matchMedia('(prefers-color-scheme: dark)').matches;
    
    // Set the theme based on localStorage or system preference
    if (currentTheme === 'dark' || (!currentTheme && isSystemDark)) {
      document.documentElement.classList.add('dark');
      themeToggleLightIcon.classList.remove('hidden');
    } else {
      document.documentElement.classList.remove('dark');
      themeToggleDarkIcon.classList.remove('hidden');
    }
    
    // Toggle the icons
    themeToggleDarkIcon.classList.toggle('hidden');
    themeToggleLightIcon.classList.toggle('hidden');
    // Toggle the dark mode class
    if (document.documentElement.classList.contains('dark')) {
      document.documentElement.classList.remove('dark');
      localStorage.setItem('color-theme', 'light');
    } else {
      document.documentElement.classList.add('dark');
      localStorage.setItem('color-theme', 'dark');
    }
    
  }

  toggle(){
    this.displayTheme();
  }
}
