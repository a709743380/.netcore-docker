# 使用 .NET 8 SDK 基礎映像來構建應用
FROM mcr.microsoft.com/dotnet/sdk:8.0 AS build

# 設定工作目錄
WORKDIR /app

# 複製解決方案檔案 (.sln) 和 csproj 檔案到容器中
COPY WebApplication3.sln ./
COPY WebApplication3/WebApplication3.csproj ./WebApplication3/

# 還原依賴
RUN dotnet restore WebApplication3.sln

# 複製剩下的檔案到容器中
COPY WebApplication3/. ./WebApplication3/

# 構建並發佈專案
RUN dotnet publish WebApplication3/WebApplication3.csproj -c Release -o out

# 使用 .NET 8 執行時映像來運行應用
FROM mcr.microsoft.com/dotnet/aspnet:8.0 AS runtime

# 設定工作目錄
WORKDIR /app

# 從 build 階段複製應用程式
COPY --from=build /app/out .

# 設定容器啟動命令
ENTRYPOINT ["dotnet", "WebApplication3.dll"]
