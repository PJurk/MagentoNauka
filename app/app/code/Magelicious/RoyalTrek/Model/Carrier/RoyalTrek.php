<?php

namespace Magelicious\RoyalTrek\Model\Carrier;

class RoyalTrek extends \Magento\Shipping\Model\Carrier\AbstractCarrier implements
  \Magento\Shipping\Model\Carrier\CarrierInterface {
  const CARRIER_CODE = 'royaltrek';

  const ROYAL_TREK_STANDARD = 'royaltrekstandard';
  const ROYAL_TREK_48HR = 'royaltrek48hr';

  protected $_code = self::CARRIER_CODE;
  protected $_isFixed = true;
  protected $_rateResultFactory;
  protected $_rateMethodFactory;

  public function __construct(
    \Magento\Framework\App\Config\ScopeConfigInterface $scopeConfig,
    \Magento\Quote\Model\Quote\Address\RateResult\ErrorFactory $rateErrorFactory,
    \Psr\Log\LoggerInterface $logger,
    \Magento\Shipping\Model\Rate\ResultFactory $rateResultFactory,
    \Magento\Quote\Model\Quote\Address\RateResult\MethodFactory $rateMethodFactory,
    array $data = []
  ) {
    $this->_rateResultFactory = $rateResultFactory;
    $this->_rateMethodFactory = $rateMethodFactory;
    parent::__construct($scopeConfig, $rateErrorFactory, $logger, $data);
  }

  public function collectRates(\Magento\Quote\Model\Quote\Address\RateRequest $request) {
    if (!$this->getConfigFlag('active')) {
      return false;
    }

    $result = $this->_rateResultFactory->create();
    $method = $this->_rateMethodFactory->create();
    $method->setCarrier($this->_code);
    $method->setCarrierTitle($this->getConfigData('title'));
    $method->setMethod(self::ROYAL_TREK_STANDARD);
    $method->setMethodTitle($this->getMethodTitle($method->getMethod()));
    $method->setPrice($this->getMethodPrice($method->getMethod()));
    $method->setCost($this->getMethodCost($method->getMethod()));
    $method->setErrorMessage(__('The %1 method error message here.'));
    $result->append($method);

    $method = $this->_rateMethodFactory->create();
    $method->setCarrier($this->_code);
    $method->setCarrierTitle($this->getConfigData('title'));
    $method->setMethod(self::ROYAL_TREK_48HR);
    $method->setMethodTitle($this->getMethodTitle($method->getMethod()));
    $method->setPrice($this->getMethodPrice($method->getMethod()));
    $method->setCost($this->getMethodCost($method->getMethod()));
    $method->setErrorMessage(__('The %1 method error message here.'));
    $result->append($method);
    
    return $result;
  }

  public function getAllowedMethods() {
    return [
      self::ROYAL_TREK_STANDARD => $this->getConfigData(self::ROYAL_TREK_STANDARD . '/title'),
      self::ROYAL_TREK_48HR => $this->getConfigData(self::ROYAL_TREK_48HR . '/title'),
    ];
  }

  private function getMethodTitle($method) {
    return $this->getConfigData($method . '/title');
  }

  private function getMethodPrice($method) {
    return $this->getMethodCost($method);
  }

  private function getMethodCost($method) {
    return $this->getConfigData($method . '/shippingcost');
  }
}