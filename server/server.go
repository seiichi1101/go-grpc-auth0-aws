package main

import (
	"context"
	"log"
	"net"

	pb "helloworld/proto/gen"

	"go.uber.org/zap"
	"google.golang.org/grpc"
	"google.golang.org/grpc/codes"
	"gopkg.in/square/go-jose.v2"
	"gopkg.in/square/go-jose.v2/jwt"

	auth0 "github.com/auth0-community/go-auth0"
	grpc_middleware "github.com/grpc-ecosystem/go-grpc-middleware"
	grpc_auth "github.com/grpc-ecosystem/go-grpc-middleware/auth"
	grpc_zap "github.com/grpc-ecosystem/go-grpc-middleware/logging/zap"
)

const (
	port = ":50051"
	// TODO: fill
	auth0_url = "<your_auth0_url>"
	audience  = "<your_audience>"
)

type server struct {
	pb.UnimplementedGreeterServer
}

func (s *server) SayHello(ctx context.Context, in *pb.HelloRequest) (*pb.HelloReply, error) {
	log.Printf("Received: %v", in.GetName())
	return &pb.HelloReply{Message: "Hello " + in.GetName() + " your id is " + ctx.Value("userId").(string)}, nil
}

func auth(ctx context.Context) (context.Context, error) {
	token, err := grpc_auth.AuthFromMD(ctx, "Bearer")
	if err != nil {
		return nil, err
	}

	parsedToken, err := jwt.ParseSigned(token)
	if err != nil {
		return nil, grpc.Errorf(codes.Unauthenticated, "Cannot parse token because of", err)
	}

	client := auth0.NewJWKClient(auth0.JWKClientOptions{URI: "https://" + auth0_url + "/.well-known/jwks.json"}, nil)
	configuration := auth0.NewConfiguration(client, []string{audience}, "https://"+auth0_url+"/", jose.RS256)
	validator := auth0.NewValidator(configuration, nil)

	if err := validator.ValidateToken(parsedToken); err != nil {
		return nil, grpc.Errorf(codes.Unauthenticated, "Cannot validate token because of", err)
	}

	claims := make(map[string]interface{})
	validator.Claims(parsedToken, &claims)

	return context.WithValue(ctx, "userId", claims["sub"]), nil
}

func main() {
	lis, err := net.Listen("tcp", port)
	if err != nil {
		log.Fatalf("failed to listen: %v", err)
	}

	zapLogger, err := zap.NewProduction()
	if err != nil {
		panic(err)
	}

	grpc_zap.ReplaceGrpcLogger(zapLogger)

	s := grpc.NewServer(
		grpc.UnaryInterceptor(
			grpc_middleware.ChainUnaryServer(
				grpc_zap.UnaryServerInterceptor(zapLogger),
				grpc_auth.UnaryServerInterceptor(auth),
			),
		),
	)
	pb.RegisterGreeterServer(s, &server{})
	if err := s.Serve(lis); err != nil {
		log.Fatalf("failed to serve: %v", err)
	}
}
