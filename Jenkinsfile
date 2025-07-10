pipeline{
 
  agent any

  stages{

      stage("build"){       
       steps{
        script {
                    def x = 10
                    def y = 5
                    def sum = x + y
                    def difference = x - y
                    def product = x * y
                    def quotient = x / y

                    echo "Sum: ${sum}"
                    echo "Difference: ${difference}"
                    echo "Product: ${product}"
                    echo "Quotient: ${quotient}"
                }
       }
      }
   
        stage("test"){       
       steps{
        echo 'auto triggering...'
        echo 'testing the application...'
       }
      }
        stage("deploy"){
       
       steps{
        echo 'deploying the application...'
        ech0 'deployement done'
       }
      }
  }

}
