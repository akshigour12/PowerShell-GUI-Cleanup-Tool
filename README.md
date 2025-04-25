# PowerShell-GUI-Cleanup-Tool
A beautifully crafted Windows Forms GUI tool written in PowerShell to help you clean up system clutter, browser cache, recent files, and even remove duplicate files — with interactive popups, dark mode, and full customization.

✨ Features
🧹 System Cleaner: Temp files, Prefetch, Recycle Bin, Downloads, Recent items

🌐 Browser Cleaner: Chrome, Edge, Firefox 

📁 Custom Path Cleanup: Add your directory

🔄 Duplicate Detection: GUI prompt for each match — supports “Yes to All”

🌙 Dark Mode Toggle: Repaints the entire GUI live

📊 Info Tab: Live CPU %, RAM, uptime & last cleanup time

✅ Progress Bar, status log, and message popups

📸 GUI Preview
☀️ Light Mode
![Light Mode](Light%20Mode.png)
🌙 Dark Mode
![Dark Mode](Dark%20Mode.png)

🚀 How to Run
Clone the repo or download the script
1. git clone https://github.com/yourusername/PowerShell-Cleanup-Tool.git
2. Open PowerShell as Administrator
3. Navigate to the script folder
4. cd "C:\Path\To\PowerShell-Cleanup-Tool"

(Optional) Temporarily bypass execution policy

Set-ExecutionPolicy -Scope Process -ExecutionPolicy Bypass

5. Run the script
.\CleanupTool.ps1

