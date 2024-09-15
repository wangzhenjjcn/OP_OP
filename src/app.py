import subprocess
import re
import requests

def get_gateways():
    try:
        # 执行 route print 命令
        result = subprocess.run(['route', 'print'], capture_output=True, text=True, shell=True)
        output = result.stdout
        print("output:",output)
        # 提取IPv4网关，假设网关在“0.0.0.0”目标的行中
        gateways = []
        lines = output.splitlines()
        
        # 遍历每一行来查找网关信息
        for line in lines:
            if re.match(r'\s+0\.0\.0\.0\s+', line):
                parts = re.findall(r'\d+\.\d+\.\d+\.\d+', line)
                if len(parts) >= 3:
                    gateways.append(parts[2])  # 通常网关在第三列

        return gateways[:8]  # 取最近的三个网关
    except Exception as e:
        print(f"Error retrieving gateways: {e}")
        return []

def check_openwrt(ip):
    try:
        # 尝试连接并检测OpenWrt
        response = requests.get(f'http://{ip}', timeout=2)
        print(ip)
        print(response.text)
        if 'openwrt.org' in response.text:
            return True
    except requests.RequestException:
        pass
    return False

def main():
    gateways = get_gateways()
    
    if not gateways:
        print("No gateways found.")
        return

    for gateway in gateways:
        print(gateway)
        if check_openwrt(gateway):
            with open('router.txt', 'w') as file:
                file.write(gateway)
            print(f"OpenWrt router found: {gateway}")
            return
    
    print("No OpenWrt routers found.")

if __name__ == "__main__":
    main()
