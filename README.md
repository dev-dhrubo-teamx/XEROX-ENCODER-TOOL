<div align="center">

<pre>
╔══════════════════════════════════════════════════════╗
║                                                      ║
║        ✦  X E R O X   E N C O D E R   T O O L  ✦      ║
║                                                      ║
║        Premium Bash-Based Video Encoder CLI          ║
║                                                      ║
╚══════════════════════════════════════════════════════╝
</pre>

<b>Version:</b> v1.5 <br>
<b>Author:</b> <a href="https://github.com/dev-dhrubo-teamx">@dev-dhrubo-teamx</a>

</div>

<hr>

<h2>🚀 Overview</h2>

<p>
<b>Xerox Encoder Tool</b> is a premium <b>Bash-based CLI video encoding tool</b> powered by <b>FFmpeg</b>.
<br><br>
It is designed for <b>VPS and server environments</b>, offering a clean
<b>minipanel-style CLI interface</b> with smart automation features —
without requiring Python, Node.js, or any additional runtime.
<br><br>
Everything runs using <b>pure Bash</b>.
</p>

<hr>

<h2>✨ Key Features</h2>

<ul>
  <li>🎬 Fast single-file video encoding</li>
  <li>🎥 High-quality HD encoding</li>
  <li>🔁 Smart folder loop encoding (auto stop after completion)</li>
  <li>💤 Background encoding using <code>nohup</code></li>
  <li>📜 Live log monitoring</li>
  <li>🧠 Automatic video extension detection</li>
  <li>⚡ Optimized FFmpeg presets</li>
  <li>🖥️ Premium colorful CLI interface</li>
  <li>🔒 No telemetry, fully open-source</li>
</ul>

<hr>

<h2>🖥️ CLI Interface Preview</h2>

<pre>
╔══════════════════════════════════════════════╗
║        ✦  X E R O X   E N C O D E R  ✦        ║
║----------------------------------------------║
║   Version : v1.5                              ║
║   Author  : @dev-dhrubo-teamx                 ║
╚══════════════════════════════════════════════╝

1) Fast Encode (Single File)
2) HD Encode (Single File)
3) Smart Loop Encode (Folder)
4) Smart Loop Encode (Background)
5) View Live Logs
6) Install Dependencies
7) Exit
</pre>

<hr>

<h2>⚙️ One-Click Installation (VPS)</h2>

<p>Run the following single command on your VPS:</p>

<pre>
curl -fsSL https://raw.githubusercontent.com/dev-dhrubo-teamx/XEROX-ENCODER-TOOL/main/install.sh | sudo bash
</pre>

<p>After installation, start the tool using:</p>

<pre>
xerox
</pre>

<p>The premium CLI interface will open immediately.</p>

<hr>

<h2>📂 Installation Structure</h2>

<pre>
/opt/xerox-encoder/
├── xerox.sh
├── output/
└── logs/
</pre>

<p>System-wide command location:</p>

<pre>
/usr/local/bin/xerox
</pre>

<hr>

<h2>📜 Logs</h2>

<p>Log file path:</p>

<pre>
/opt/xerox-encoder/logs/encoder.log
</pre>

<p>Live log view (optional):</p>

<pre>
tail -f /opt/xerox-encoder/logs/encoder.log
</pre>

<hr>

<h2>🧪 Tested Environments</h2>

<ul>
  <li>Ubuntu 20.04 / 22.04</li>
  <li>Debian 11 / 12</li>
  <li>VPS environments (DigitalOcean, Hetzner, Contabo, AWS EC2)</li>
</ul>

<hr>

<h2>🔐 Security & Transparency</h2>

<ul>
  <li>No hidden binaries</li>
  <li>No background services without user action</li>
  <li>No telemetry or tracking</li>
  <li>100% open-source Bash script</li>
  <li>Full user control</li>
</ul>

<hr>

<h2>🛠️ Roadmap</h2>

<ul>
  <li>Auto update (<code>xerox update</code>)</li>
  <li>Theme switch (dark / light)</li>
  <li>Encoding progress percentage</li>
  <li>Resume interrupted encodes</li>
</ul>

<hr>

<h2>👤 Author & Credit</h2>

<p>
<b>Developed and maintained by:</b><br>
👉 <a href="https://github.com/dev-dhrubo-teamx">@dev-dhrubo-teamx</a>
</p>

<p>If you find this project useful, please ⭐ star the repository and share it.</p>

<hr>

<div align="center">
<b>✦ Xerox Encoder Tool — Encode Smarter ✦</b>
</div>

# 1 Click Encoding Command 

```
for f in *.mkv; do ffmpeg -i "$f" -c:v libx264 -preset ultrafast -crf 28 -c:a aac -b:a 128k -movflags +faststart "${f%.mkv}.mp4" && rm -f "$f"; done
```
