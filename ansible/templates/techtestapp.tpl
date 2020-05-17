[Unit]
Description = Tech test service by Servian

[Service]
Type=simple
User=root
WorkingDirectory=/etc/TechTestApp/dist/
ExecStart=/etc/TechTestApp/dist/TechTestApp serve

[Install]
WantedBy=multi-user.target